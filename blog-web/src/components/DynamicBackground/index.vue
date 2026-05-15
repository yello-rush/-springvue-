<template>
  <div>
    <canvas ref="canvas" class="dynamic-background"></canvas>
  </div>
</template>

<script>
export default {
  name: 'DynamicBackground',
  props: {
    intensity: { type: Number, default: 1.0 },
    density: { type: Number, default: 80 },
    themeColor: { type: String, default: '#6366f1' }
  },
  data() {
    return {
      ctx: null,
      particles: [],
      mouse: { x: null, y: null, radius: 150 },
      animationFrameId: null,
      resizeTimeout: null,
      
      localIntensity: this.intensity,
      localDensity: this.density,
      localThemeColor: this.themeColor
    };
  },
  mounted() {
    this.initCanvas();
    this.createParticles();
    this.animate();
    window.addEventListener('resize', this.handleResize);
    window.addEventListener('mousemove', this.handleMouseMove);
    window.addEventListener('mouseout', this.handleMouseOut);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
    window.removeEventListener('mousemove', this.handleMouseMove);
    window.removeEventListener('mouseout', this.handleMouseOut);
    if (this.animationFrameId) {
      cancelAnimationFrame(this.animationFrameId);
    }
  },
  watch: {
    localDensity() {
      this.createParticles();
    }
  },
  methods: {
    initCanvas() {
      const canvas = this.$refs.canvas;
      this.ctx = canvas.getContext('2d');
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    },
    handleResize() {
      if (this.resizeTimeout) clearTimeout(this.resizeTimeout);
      this.resizeTimeout = setTimeout(() => {
        this.initCanvas();
        this.createParticles();
      }, 200);
    },
    handleMouseMove(e) {
      this.mouse.x = e.x;
      this.mouse.y = e.y;
    },
    handleMouseOut() {
      this.mouse.x = null;
      this.mouse.y = null;
    },
    hexToRgb(hex) {
      const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
      return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
      } : { r: 99, g: 102, b: 241 };
    },
    createParticles() {
      const canvas = this.$refs.canvas;
      this.particles = [];
      const particleCount = Math.floor((canvas.width * canvas.height) / (10000 * (1 / (this.localDensity / 100))));
      
      const rgb = this.hexToRgb(this.localThemeColor);

      for (let i = 0; i < particleCount; i++) {
        let size = (Math.random() * 3) + 1;
        let x = Math.random() * (canvas.width - size * 2) + size * 2;
        let y = Math.random() * (canvas.height - size * 2) + size * 2;
        let directionX = (Math.random() * 0.8) - 0.4;
        let directionY = (Math.random() * 0.8) - 0.4;
        let color = `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, ${Math.random() * 0.5 + 0.1})`;

        this.particles.push({
          x, y, directionX, directionY, size, color, baseSize: size
        });
      }
    },
    animate() {
      this.animationFrameId = requestAnimationFrame(this.animate);
      this.ctx.clearRect(0, 0, this.$refs.canvas.width, this.$refs.canvas.height);
      
      for (let i = 0; i < this.particles.length; i++) {
        let p = this.particles[i];
        this.updateParticle(p);
        this.drawParticle(p);
      }
      this.connectParticles();
    },
    updateParticle(p) {
      const canvas = this.$refs.canvas;
      if (p.x > canvas.width || p.x < 0) p.directionX = -p.directionX;
      if (p.y > canvas.height || p.y < 0) p.directionY = -p.directionY;

      if (this.mouse.x != null && this.mouse.y != null) {
        let dx = this.mouse.x - p.x;
        let dy = this.mouse.y - p.y;
        let distance = Math.sqrt(dx * dx + dy * dy);
        
        if (distance < this.mouse.radius) {
          const forceDirectionX = dx / distance;
          const forceDirectionY = dy / distance;
          const force = (this.mouse.radius - distance) / this.mouse.radius;
          
          p.x -= forceDirectionX * force * 5 * this.localIntensity;
          p.y -= forceDirectionY * force * 5 * this.localIntensity;
        }
      }
      
      p.x += p.directionX * this.localIntensity;
      p.y += p.directionY * this.localIntensity;
    },
    drawParticle(p) {
      this.ctx.beginPath();
      this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2, false);
      
      // Update color if theme changed dynamically
      const rgb = this.hexToRgb(this.localThemeColor);
      const alpha = parseFloat(p.color.split(',')[3]) || 0.5;
      p.color = `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, ${alpha})`;
      
      this.ctx.fillStyle = p.color;
      this.ctx.fill();
    },
    connectParticles() {
      const rgb = this.hexToRgb(this.localThemeColor);
      for (let a = 0; a < this.particles.length; a++) {
        for (let b = a; b < this.particles.length; b++) {
          let dx = this.particles[a].x - this.particles[b].x;
          let dy = this.particles[a].y - this.particles[b].y;
          let distance = dx * dx + dy * dy;
          
          if (distance < (this.$refs.canvas.width/7) * (this.$refs.canvas.height/7)) {
            let opacity = 1 - (distance / ((this.$refs.canvas.width/7) * (this.$refs.canvas.height/7)));
            this.ctx.strokeStyle = `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, ${opacity * 0.2})`;
            this.ctx.lineWidth = 1;
            this.ctx.beginPath();
            this.ctx.moveTo(this.particles[a].x, this.particles[a].y);
            this.ctx.lineTo(this.particles[b].x, this.particles[b].y);
            this.ctx.stroke();
          }
        }
      }
    }
  }
};
</script>

<style scoped>
.dynamic-background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 0;
  pointer-events: none;
  background: transparent;
}
</style>

