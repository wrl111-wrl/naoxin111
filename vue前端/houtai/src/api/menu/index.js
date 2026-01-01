import request from '@/utils/request';

export function useMenuApi() {
	return {
		getMenuGuanliyuan: (params) => {
			// 本地数据，路径：`/public/xxx.json`
			return request({
				url: '/guanliyuan.json',
				method: 'get',
				params,
			});

		},
		getMenuJiaoshi: (params) => {
			return request({
				url: '/jiaoshi.json',
				method: 'get',
				params,
			});
		},
		getMenuXuesheng: (params) => {
			return request({
				url: '/xuesheng.json',
				method: 'get',
				params,
			});
		},

		
	};
}
