const mysql = require('mysql2/promise');

async function syncAvatars() {
    const connection = await mysql.createConnection({
        host: '127.0.0.1',
        user: 'root',
        password: '1234',
        database: 'blog'
    });

    try {
        console.log('Fetching existing distinct user avatars...');
        const [users] = await connection.execute('SELECT DISTINCT avatar FROM sys_user WHERE avatar IS NOT NULL AND avatar != ""');
        
        console.log(`Found ${users.length} distinct avatars.`);

        for (const user of users) {
            const avatarUrl = user.avatar;
            // check if it already exists in sys_photo under album 9
            const [photos] = await connection.execute('SELECT id FROM sys_photo WHERE url = ? AND album_id = 9', [avatarUrl]);
            
            if (photos.length === 0) {
                console.log(`Inserting avatar into photo gallery 9: ${avatarUrl}`);
                await connection.execute(
                    'INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time) VALUES (?, ?, ?, ?, NOW(), NOW())',
                    [9, avatarUrl, '用户历史头像', 1]
                );
            }
        }
        console.log('Sync complete.');
    } catch (err) {
        console.error('Error syncing avatars:', err);
    } finally {
        await connection.end();
    }
}

syncAvatars();