﻿﻿import Vue from 'vue';
import store from '../store';
import VueRouter from 'vue-router';
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';
import { Session } from '@/utils/storage';
import { PrevLoading } from '@/utils/loading.js';
import { useMenuApi } from '@/api/menu';

const menuApi = useMenuApi();

// 解决 `element ui` 导航栏重复点菜单报错问题
const originalPush = VueRouter.prototype.push;
VueRouter.prototype.push = function push(location) {
	return originalPush.call(this, location).catch((err) => err);
};

// 安装 VueRouter 插件
Vue.use(VueRouter);

// 定义动态路由
const dynamicRoutes = [
	{
		path: '/',
		name: '/',
		component: 'layout/index',
		redirect: '/home',
		meta: {
			isKeepAlive: true,
		},
		children: [],
	},
];

// 定义静态路由
const staticRoutes = [
	{
		path: '/login',
		name: 'login',
		component: () => import('@/views/login'),
		meta: {
			title: '登录',
		},
	},
	{
		path: '/register',
		name: 'register',
		component: () => import('@/views/register'),
		meta: {
			title: '注册',
		},
	},
	{
		path: '/404',
		name: 'notFound',
		component: () => import('@/views/error/404.vue'),
		meta: {
			title: 'message.staticRoutes.notFound',
		},
	},
	{
		path: '/401',
		name: 'noPower',
		component: () => import('@/views/error/401.vue'),
		meta: {
			title: 'message.staticRoutes.noPower',
		},
	},
];

// 加载静态路由
const createRouter = () =>
	new VueRouter({
		routes: staticRoutes,
	});

// 创建路由
const router = createRouter();

// 加载 loading
PrevLoading.start();

// 多级嵌套数组处理成一维数组
export function formatFlatteningRoutes(arr) {
	if (arr.length <= 0) return false;
	for (let i = 0; i < arr.length; i++) {
		if (arr[i].children) {
			arr = arr.slice(0, i + 1).concat(arr[i].children, arr.slice(i + 1));
		}
	}
	return arr;
}

// 处理 tagsViewList 数据，默认路由全部缓存
// isKeepAlive 处理 `name` 值，进行路由缓存
export function formatTwoStageRoutes(arr) {
	if (arr.length <= 0) return false;
	const newArr = [];
	const cacheList = [];
	arr.forEach((v) => {
		newArr.push({ ...v });
		cacheList.push(v.name);
	});
	store.dispatch('keepAliveNames/setCacheKeepAlive', cacheList);
	return newArr;
}

// 判断路由 meta.roles 中是否包含当前登录用户权限字段
export function hasAuth(roles, route) {
	if (route.meta && route.meta.roles) 
		return roles.some((role) => route.meta.roles.includes(role));
	else 
		return true;
}

// 递归过滤有权限的路由
export function setFilterMenuFun(routes, role) {
	const menu = [];
	routes.forEach((route) => {
		const item = { ...route };
		if (hasAuth(role, item)) {
			if (item.children) item.children = setFilterMenuFun(item.children, role);
			menu.push(item);
		}
	});
	return menu;
}

// 缓存多级嵌套数组处理后的一维数组(tagsView、菜单搜索中使用：未过滤隐藏的(isHide))
export function setCacheTagsViewRoutes(arr) {
	// 先处理有权限的路由，否则 tagsView、菜单搜索中无权限的路由也将显示
	let rolesRoutes = setFilterMenuFun(arr, store.state.userInfos.userInfos.roles);
	// 添加到 vuex setTagsViewRoutes 中
	store.dispatch('tagsViewRoutes/setTagsViewRoutes', formatTwoStageRoutes(formatFlatteningRoutes(rolesRoutes)));
}

// 递归处理多余的 layout : <router-view>，让需要访问的组件保持在第一层 layout 层。
// 因为 `keep-alive` 只能缓存二级路由
// 默认初始化时就执行
export function keepAliveSplice(to) {
	if (to.matched && to.matched.length > 2) {
		to.matched.forEach((v, k) => {
			if (v.components && v.components.default) {
				if (v.components.default.name === 'parent') {
					to.matched.splice(k, 1);
					keepAliveSplice(to);
				}
			}
		});
	}
}

// 处理后端返回的 `component` 路径，拼装实现懒加载
export function loadView(path) {
	if (path.indexOf('layout') > -1) 
		return () => import(`@/${path}`);
	else 
		return () => import(`@/views/${path}`);
}

// 递归处理每一项 `component` 中的路径
export function dynamicRouter(routes) {
	return routes.map((view) => {
		if (view.component) view.component = loadView(view.component);
		if (view.children) dynamicRouter(view.children);
		return view;
	});
}

// 重置路由
export function resetRouter() {
	router.matcher = createRouter().matcher;
}

// 延迟关闭进度条
export function delayNProgressDone(time = 300) {
	setTimeout(() => {
		NProgress.done();
	}, time);
}

// 公共函数：处理用户路由
async function handleUserRoutes(router, to, next, apiMethod) {
	try {
		resetRouter();
		
		// 调用对应的API方法获取菜单
		const res = await apiMethod();
		
		// 读取用户信息，获取对应权限进行判断
		await store.dispatch('userInfos/setUserInfos');
		
		// 过滤有权限的路由
		const filteredRoutes = setFilterMenuFun(res.data, store.state.userInfos.userInfos.roles);
		
		// 设置路由列表
		store.dispatch('routesList/setRoutesList', filteredRoutes);
		
		// 设置动态路由
		dynamicRoutes[0].children = res.data;
		const awaitRoute = dynamicRouter(dynamicRoutes);
		
		// 添加动态路由和404路由
		[...awaitRoute, { path: '*', redirect: '/404' }].forEach((route) => {
			router.addRoute({ ...route });
		});
		
		// 设置tagsView
		setCacheTagsViewRoutes(JSON.parse(JSON.stringify(res.data)));
		
		// 跳转到目标路由
		next({ ...to, replace: true });
	} catch (error) {
		console.error('加载菜单失败:', error);
		// 如果API调用失败，跳转到首页或登录页
		next('/home');
	}
}

// 管理员用户路由
export function guanliyuanUser(router, to, next) {
	handleUserRoutes(router, to, next, menuApi.getMenuGuanliyuan);
}

// 教师用户路由
export function jiaoshiUser(router, to, next) {
	handleUserRoutes(router, to, next, menuApi.getMenuJiaoshi);
}

// 学生用户路由
export function xueshengUser(router, to, next) {
	handleUserRoutes(router, to, next, menuApi.getMenuXuesheng);
}

// 动态加载后端返回路由(模拟数据)
export function getRouterList(router, to, next) {
	if (!Session.get('userInfo')) {
		next('/login');
		return;
	}
	
	const userRole = Session.get('userInfo').roles[0];
	
	switch (userRole) {
		case 'guanliyuan':
			guanliyuanUser(router, to, next);
			break;
		case 'jiaoshi':
			jiaoshiUser(router, to, next);
			break;
		case 'xuesheng':
			xueshengUser(router, to, next);
			break;
		default:
			// 如果没有匹配的角色，跳转到首页
			next('/home');
			break;
	}
}

// 路由加载前
router.beforeEach((to, from, next) => {
	keepAliveSplice(to);
	NProgress.configure({ showSpinner: false });
	
	// 设置页面标题
	if (to.meta.title && to.path !== '/login') {
		NProgress.start();
		document.title = to.meta.title;
	}
	
	let token = Session.get('token');
	
	// 处理注册页面
	if (to.path === '/register') {
		next();
		return;
	}
	
	// 处理登录页面
	if (to.path === '/login') {
		if (token) {
			// 已登录，跳转到首页
			next('/home');
		} else {
			// 未登录，允许访问登录页
			next();
		}
		delayNProgressDone();
		return;
	}
	
	// 需要登录的页面
	if (!token) {
		// 没有token，跳转到登录页
		next('/login');
		Session.clear();
		delayNProgressDone();
		return;
	}
	
	// 已登录，但有路由未加载
	if (Object.keys(store.state.routesList.routesList).length <= 0 && Session.get('userInfo')) {
		getRouterList(router, to, next);
	} else {
		next();
		delayNProgressDone(0);
	}
});

// 路由加载后
router.afterEach(() => {
	PrevLoading.done();
	delayNProgressDone();
});

// 导出路由
export default router;