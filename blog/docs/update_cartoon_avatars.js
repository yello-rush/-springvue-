const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
const https = require('https');

const downloadImage = (url, dest) => {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(dest);
        https.get(url, (response) => {
            if (response.statusCode !== 200) {
                reject(new Error(`Failed to get '${url}' (${response.statusCode})`));
                return;
            }
            response.pipe(file);
            file.on('finish', () => {
                file.close(resolve);
            });
        }).on('error', (err) => {
            fs.unlink(dest, () => reject(err));
        });
    });
};

async function run() {
    const connection = await mysql.createConnection({
        host: '127.0.0.1',
        user: 'root',
        password: '1234',
        database: 'blog'
    });

    try {
        console.log('1. Clearing old default avatars in DB...');
        await connection.execute('DELETE FROM sys_photo WHERE album_id = 8');

        const webGallery = path.join(__dirname, '../../blog-web/public/gallery');
        const adminGallery = path.join(__dirname, '../../blog-admin/public/gallery');

        // Ensure dirs exist
        if (!fs.existsSync(webGallery)) fs.mkdirSync(webGallery, { recursive: true });
        if (!fs.existsSync(adminGallery)) fs.mkdirSync(adminGallery, { recursive: true });

        console.log('2. Downloading 10 cartoon avatars...');
        // We use avataaars style for beautiful cartoon characters
        const seeds = ['Felix', 'Aneka', 'Jasper', 'Nala', 'Boots', 'Whiskers', 'Luna', 'Simba', 'Oliver', 'Milo'];
        
        for (let i = 0; i < 10; i++) {
            const seed = seeds[i];
            const url = `https://api.dicebear.com/7.x/avataaars/png?seed=${seed}&backgroundColor=b6e3f4,c0aede,d1d4f9,ffdfbf,ffd5dc`;
            const filename = `cartoon-${i + 1}.png`;
            const webPath = path.join(webGallery, filename);
            const adminPath = path.join(adminGallery, filename);

            console.log(`Downloading ${filename}...`);
            await downloadImage(url, webPath);
            fs.copyFileSync(webPath, adminPath);

            const dbUrl = `/gallery/${filename}`;
            await connection.execute(
                'INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time) VALUES (?, ?, ?, ?, NOW(), NOW())',
                [8, dbUrl, `卡通头像 ${i + 1}`, i + 1]
            );
        }
        
        console.log('3. Updating sys_user old avatars to the new cartoon ones...');
        const [users] = await connection.execute('SELECT id, avatar FROM sys_user WHERE avatar LIKE "/gallery/avatar%"');
        for (const user of users) {
            const randomId = Math.floor(Math.random() * 10) + 1;
            const newAvatar = `/gallery/cartoon-${randomId}.png`;
            await connection.execute('UPDATE sys_user SET avatar = ? WHERE id = ?', [newAvatar, user.id]);
        }

        console.log('Done!');
    } catch (err) {
        console.error(err);
    } finally {
        await connection.end();
    }
}
run();