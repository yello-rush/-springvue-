const mysql = require('mysql2/promise');

const config = {
  host: '127.0.0.1',
  user: 'root',
  password: 'root',
  database: 'blog'
};

async function seed() {
  const connection = await mysql.createConnection(config);
  try {
    // 1. Ensure favorite_num column exists
    try {
      await connection.query("ALTER TABLE sys_article ADD COLUMN favorite_num INT DEFAULT 0 COMMENT '收藏数量';");
      console.log('Added favorite_num column.');
    } catch (e) {
      if (e.code !== 'ER_DUP_FIELDNAME') throw e;
    }

    // 2. Fetch all articles
    const [articles] = await connection.query('SELECT id FROM sys_article');
    console.log(`Found ${articles.length} articles.`);

    // Tracking sets to ensure uniqueness
    const generatedLikes = new Set();
    const generatedFavorites = new Set();
    const generatedViews = new Set();
    
    // Create users if needed or just use random user_ids
    const users = Array.from({ length: 20 }, (_, i) => i + 1);

    for (const article of articles) {
      const articleId = article.id;

      // Unique Likes
      let likes;
      do {
        // Power-law distribution (approx)
        const rand = Math.random();
        likes = Math.round(Math.pow(rand, 3) * 490 + 10); 
      } while (generatedLikes.has(likes));
      generatedLikes.add(likes);

      // Unique Favorites
      let favorites;
      do {
        const corr = 0.3 + Math.random() * 0.2; // 0.3-0.5
        favorites = Math.round(likes * corr);
        if (favorites < 5) favorites = 5;
        if (favorites > 200) favorites = 200;
        // ensure uniqueness even with bounds
        while (generatedFavorites.has(favorites)) {
          favorites += 1;
        }
      } while (generatedFavorites.has(favorites));
      generatedFavorites.add(favorites);

      // Unique Views
      let views;
      do {
        const multiplier = 5 + Math.random() * 10; // 5-15x
        views = Math.round(likes * multiplier);
        if (views < 100) views = 100;
        if (views > 5000) views = 5000;
        while (generatedViews.has(views)) {
          views += 1;
        }
      } while (generatedViews.has(views));
      generatedViews.add(views);

      // Dates
      const now = Date.now();
      const past365 = now - 365 * 24 * 60 * 60 * 1000;
      const createTime = new Date(past365 + Math.random() * (365 * 24 * 60 * 60 * 1000));
      
      const updateInterval = Math.random() * 90 * 24 * 60 * 60 * 1000;
      const updateTime = new Date(Math.min(now, createTime.getTime() + updateInterval));

      // Update sys_article
      await connection.query(
        'UPDATE sys_article SET quantity = ?, favorite_num = ?, create_time = ?, update_time = ? WHERE id = ?',
        [views, favorites, createTime, updateTime, articleId]
      );

      // Insert likes
      await connection.query('DELETE FROM sys_article_like WHERE article_id = ?', [articleId]);
      for (let i = 0; i < likes; i++) {
        // Just mock user_id, since sys_article_like just needs a user_id
        await connection.query('INSERT INTO sys_article_like (article_id, user_id) VALUES (?, ?)', [articleId, users[i % users.length] + Math.floor(Math.random() * 100)]);
      }

      // Insert comments
      await connection.query('DELETE FROM sys_comment WHERE article_id = ?', [articleId]);
      const commentCount = Math.floor(Math.random() * 11) + 5; // 5-15
      
      // Generate ascending timestamps for comments
      const commentTimes = Array.from({ length: commentCount }, () => {
         return new Date(createTime.getTime() + Math.random() * (now - createTime.getTime()));
      }).sort((a, b) => a - b);

      for (let i = 0; i < commentCount; i++) {
        const userId = users[Math.floor(Math.random() * users.length)];
        const content = `Mock comment ${i + 1} for article ${articleId}`;
        await connection.query(
          'INSERT INTO sys_comment (article_id, user_id, content, create_time) VALUES (?, ?, ?, ?)',
          [articleId, userId, content, commentTimes[i]]
        );
      }
      console.log(`Processed article ${articleId} - Likes: ${likes}, Favs: ${favorites}, Views: ${views}, Comments: ${commentCount}`);
    }

    console.log('Seeding completed successfully.');
  } catch (error) {
    console.error('Error during seeding:', error);
  } finally {
    await connection.end();
  }
}

seed();
