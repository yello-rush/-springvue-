<template>
  <footer class="site-footer">
    <div class="footer-content">
      <div class="footer-info">
        <div class="project-info">
          <h3>基于Spring+Vue的个人博客系统</h3>
          <p>Graduation Project Blog System</p>
        </div>
        <div class="copyright">
          <p>Copyright © {{ currentYear }} 黄翀 (学号:2022070030132)</p>
          <span class="divider">|</span>
          <p>桂林航天工业学院 软件工程专业</p>
        </div>

      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: 'TheFooter',
  computed: {
    currentYear() {
      return new Date().getFullYear()
    }
  }
}
</script>

<style lang="scss" scoped>
.site-footer {
  background: var(--card-bg);
  color: var(--text-secondary);
  padding: 40px 0;
  margin-top: auto;
  border-top: 1px solid rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  position: relative;
  z-index: 1;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.footer-info {
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.project-info {
  h3 {
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 5px;
    font-family: "LXGW WenKai", sans-serif;
  }
  
  p {
    font-size: 0.8rem;
    opacity: 0.7;
    text-transform: uppercase;
    letter-spacing: 1px;
  }
}

.copyright {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  gap: 10px;
  font-size: 0.9rem;
  
  p {
    margin: 0;
  }
  
  .divider {
    opacity: 0.3;
  }
}

.beian {
  font-size: 0.85rem;
  
  a {
    color: var(--text-secondary);
    text-decoration: none;
    transition: color 0.3s;
    
    &:hover {
      color: var(--primary);
    }
  }
}

@media (max-width: 768px) {
  .site-footer {
    padding: 30px 0;
  }
  
  .copyright {
    flex-direction: column;
    gap: 5px;
    
    .divider {
      display: none;
    }
  }
}
</style>
