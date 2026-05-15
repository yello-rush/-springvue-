const mysql = require('mysql2/promise');

async function restore10086() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234',
    database: 'blog'
  });

  try {
    // Restore the specific cat avatar for 10086
    const catUrl = "http://127.0.0.1:8800/localFile/local-plus/20260425/avatar/83_avatar.jpg";
    await connection.execute('UPDATE sys_user SET avatar = ? WHERE email="10086@qq.com" OR username="10086@qq.com"', [catUrl]);
    console.log("Restored 10086 avatar to " + catUrl);
  } finally {
    await connection.end();
  }
}
restore10086();