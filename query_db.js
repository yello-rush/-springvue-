const mysql = require('mysql2/promise');
async function run() {
  const conn = await mysql.createConnection({
    host: 'localhost', user: 'root', password: '1234', database: 'blog'
  });
  const [rows] = await conn.execute('SELECT name, logo FROM sys_web_info LIMIT 1');
  console.log(rows);
  await conn.end();
}
run();