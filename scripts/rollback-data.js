const mysql = require('mysql2/promise');

const config = {
  host: '127.0.0.1',
  user: 'root',
  password: 'root',
  database: 'blog'
};

async function rollback() {
  const connection = await mysql.createConnection(config);
  try {
    // 1. Remove favorite_num column
    try {
      await connection.query("ALTER TABLE sys_article DROP COLUMN favorite_num;");
      console.log('Removed favorite_num column.');
    } catch (e) {
      if (e.code !== 'ER_CANT_DROP_FIELD_OR_KEY') throw e;
    }

    // 2. Clear mocked comments and likes 
    // Assuming we want to clear everything or maybe just the ones we generated? 
    // Since it's a dev environment and testing data, we can truncate or delete them.
    await connection.query("TRUNCATE TABLE sys_article_like;");
    await connection.query("TRUNCATE TABLE sys_comment;");
    console.log('Cleared sys_article_like and sys_comment tables.');

    console.log('Rollback completed successfully.');
  } catch (error) {
    console.error('Error during rollback:', error);
  } finally {
    await connection.end();
  }
}

rollback();
