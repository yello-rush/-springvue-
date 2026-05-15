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
    const [defaultAlbumRows] = await connection.execute('SELECT id FROM sys_album WHERE name = "默认头像库"');
    if (defaultAlbumRows.length === 0) {
      console.log('默认头像库不存在');
      return;
    }
    const defaultAlbumId = defaultAlbumRows[0].id;
    const [photos] = await connection.execute('SELECT url FROM sys_photo WHERE album_id = ?', [defaultAlbumId]);
    if (photos.length === 0) {
      console.log('默认头像库中没有图片');
      return;
    }
    const photoUrls = photos.map(p => p.url);

    // 给用户名为 "测试" 等的测试用户的头像填充默认图片
    const [users] = await connection.execute('SELECT id, avatar, nickname FROM sys_user');
    
    let updatedUsers = 0;
    for (let user of users) {
      // 只要是外链、或者未设置，或者是测试账号，就给它换成默认头像
      if (!user.avatar || user.avatar.includes('http') || user.avatar.includes('dicebear') || user.avatar.includes('visitor.png') || (user.nickname && user.nickname.includes('测试'))) {
        let avatar = photoUrls[Math.floor(Math.random() * photoUrls.length)];
        await connection.execute('UPDATE sys_user SET avatar = ? WHERE id = ?', [avatar, user.id]);
        updatedUsers++;
      }
    }
    console.log(`Updated ${updatedUsers} users with random default avatars`);
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    await connection.end();
  }
}

seed().catch(console.error);