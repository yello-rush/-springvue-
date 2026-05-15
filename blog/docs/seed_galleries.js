const mysql = require('mysql2/promise');

async function seed() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234',
    database: 'blog'
  });

  try {
    console.log('Connected to DB');

    // 1. Ensure albums exist
    const albums = [
      { name: '默认头像库', desc: '用于新注册用户随机抽取的默认头像', cover: '/gallery/avatar-lib-1.jpg' },
      { name: '用户头像图库', desc: '用于存储用户上传的自定义头像', cover: '/gallery/avatar-lib-5.jpg' },
      { name: '管理员图库', desc: '用于存储管理员上传的其他图片', cover: '/gallery/cover-1.jpg' }
    ];

    for (let album of albums) {
      const [rows] = await connection.execute('SELECT id FROM sys_album WHERE name = ?', [album.name]);
      if (rows.length === 0) {
        await connection.execute(
          'INSERT INTO sys_album (name, description, cover, is_lock, sort, create_time) VALUES (?, ?, ?, 0, 1, NOW())',
          [album.name, album.desc, album.cover]
        );
        console.log(`Created album: ${album.name}`);
      } else {
        console.log(`Album already exists: ${album.name}`);
      }
    }

    // 2. Get ID of 默认头像库
    const [defaultAlbumRows] = await connection.execute('SELECT id FROM sys_album WHERE name = "默认头像库"');
    const defaultAlbumId = defaultAlbumRows[0].id;

    // 3. Check if photos are already inserted
    const [existingPhotos] = await connection.execute('SELECT count(*) as cnt FROM sys_photo WHERE album_id = ?', [defaultAlbumId]);
    if (existingPhotos[0].cnt < 10) {
      // Clear existing photos in this album to prevent duplicates if partially run
      await connection.execute('DELETE FROM sys_photo WHERE album_id = ?', [defaultAlbumId]);

      // Insert 10 avatars
      for (let i = 1; i <= 10; i++) {
        await connection.execute(
          'INSERT INTO sys_photo (album_id, url, description, sort, record_time, create_time) VALUES (?, ?, ?, ?, DATE(NOW()), NOW())',
          [defaultAlbumId, `/gallery/avatar-lib-${i}.jpg`, `默认头像 ${i}`, i]
        );
      }
      console.log('Inserted 10 default avatars into 默认头像库');
    } else {
      console.log('10 default avatars already exist in 默认头像库');
    }

    // 4. Update users with missing avatars
    // Fetch photos
    const [photos] = await connection.execute('SELECT url FROM sys_photo WHERE album_id = ?', [defaultAlbumId]);
    if (photos.length > 0) {
      const photoUrls = photos.map(p => p.url);
      
      const [users] = await connection.execute('SELECT id, avatar FROM sys_user WHERE avatar IS NULL OR avatar = "" OR avatar = "/visitor.png" OR avatar = "https://api.dicebear.com/7.x/miniavs/svg?seed=visitor"');
      
      let updatedUsers = 0;
      for (let user of users) {
        const randomUrl = photoUrls[Math.floor(Math.random() * photoUrls.length)];
        await connection.execute('UPDATE sys_user SET avatar = ? WHERE id = ?', [randomUrl, user.id]);
        updatedUsers++;
      }
      console.log(`Updated ${updatedUsers} users with random default avatars`);
    }

  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    await connection.end();
  }
}

seed().catch(console.error);