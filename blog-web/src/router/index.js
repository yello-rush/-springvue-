import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '@/views/home/index.vue'
import Layout from '@/layout/index.vue'
import NotFound from '@/views/404/404.vue'
import Article from '@/views/article/index.vue'
import Archive from '@/views/archives/index.vue'
import Categories from '@/views/categories/index.vue'
import Tags from '@/views/tags/index.vue'
import store from '@/store';

Vue.use(VueRouter)

const routes = [

    {
        path: "/",
        component: Layout,
        meta: {
            title: "习习中博客系统",
            loading: true
        },
        children: [
            {
                path: '/',
                name: 'Home',
                component: Home,
                meta: {
                    title: '首页',
                    transition: 'fade',
                    icon: 'fas fa-home',
                    loading: true
                 }
              },
              {
                path: '/archives',
                name: 'Archive',
                component: Archive,
                meta: { 
                  transition: 'fade',
                  title: '归档',
                  icon: 'fas fa-archive'
                }
              },
              {
                path: '/categories',
                name: 'Categories',
                component: Categories,
                meta: {
                    transition: 'fade',
                    title: "分类",
                    icon: 'fas fa-folder'
                 }
              },
              {
                path: '/tags',
                name: 'Tags',
                component: Tags,
                meta: {
                    transition: 'fade',
                    title: '标签',
                    icon: 'fas fa-tags'
                }
              },
              {
                path: '/moments',
                name: 'Moments',
                component: () => import('@/views/moments/index.vue'),
                meta: {
                  title: '说说',
                  icon: 'fas fa-comment-dots'
                }
              },
              {
                path: '/messages',
                name: 'MessageBoard',
                component: () => import('@/views/messages/index.vue'),
                meta: {
                  title: '留言板',
                  icon: 'fas fa-comments'
                }
              },
              {
                path: '/post/:id',
                name: 'Post',
                component: Article,
                props: true,
                meta: {
                  hidden: true
                }
              },
              {
                path: '/article/:id/revision',
                name: 'ArticleRevision',
                component: () => import('@/views/article/revision.vue'),
                meta: {
                  title: '版本历史',
                  hidden: true
                }
              },
              {
                path: '/user/profile',
                name: 'Profile',
                component: () => import(/* webpackPrefetch: true */ '@/views/profile/index.vue'),
                meta: {
                  title: '个人主页',
                  icon: 'fas fa-user',
                  hidden: true
                }
              },
              {
                path: '/profile',
                redirect: '/user/profile'
              },
              {
                path: '/user',
                redirect: '/user/profile'
              },
              {
                path: '/login',
                name: 'Login',
                component: () => import('@/views/login/index.vue'),
                meta: {
                  title: '登录',
                  hidden: true,
                  fullscreen: true
                }
              },
              {
                path: '*',
                name: 'NotFound',
                component: NotFound,
                meta: {
                  hidden: true
                }
              }
        ]
    }
]

const router = new VueRouter({
  mode: 'hash',
  routes,
  scrollBehavior(to, from, savedPosition) {
    return { x: 0, y: 0 }
  }
})


// 解决重复点击导航时，控制台出现报错
const VueRouterPush = VueRouter.prototype.push
VueRouter.prototype.push = function push (to) {
  return VueRouterPush.call(this, to).catch(err => err)
}


router.beforeEach((to, from, next) => {
  if (to.meta.title) {
    document.title = to.meta.title
  }
  //关闭搜索框
  store.commit('SET_SEARCH_VISIBLE', false)
  next()
})

export default router 
