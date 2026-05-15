const mysql = require('mysql2/promise');

async function fix10086() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234',
    database: 'blog'
  });

  try {
    console.log('Connected to DB');
    
    // Find if there's an image uploaded by this user in sys_photo, or just give it a cat image
    // If not, we'll try to find any avatar that looks like a cat, or just use one of the downloaded avatars.
    // The user said "是一只白色小猫的形式" (a white cat).
    // Let's check if there's any avatar in sys_photo that might be it.
    const [photos] = await connection.execute('SELECT * FROM sys_photo WHERE url LIKE "%cat%" OR url LIKE "%mao%"');
    console.log("Found photos:", photos);
    
    // Check current 10086 user
    const [users] = await connection.execute('SELECT * FROM sys_user WHERE username="10086@qq.com" OR email="10086@qq.com"');
    console.log("User 10086:", users);

    // I will search all users' avatars just to see if we can find the cat avatar in history or elsewhere, but actually I might just search the local file system.
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    await connection.end();
  }
}

fix10086().catch(console.error);