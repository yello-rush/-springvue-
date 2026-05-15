const mysql = require('mysql2/promise');

async function checkPhotos() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234',
    database: 'blog'
  });

  try {
    const [photos] = await connection.execute('SELECT * FROM sys_photo ORDER BY id DESC LIMIT 50');
    console.log("Recent photos:");
    for (let p of photos) {
      console.log(p.id, p.url, p.album_id);
    }
  } finally {
    await connection.end();
  }
}
checkPhotos();