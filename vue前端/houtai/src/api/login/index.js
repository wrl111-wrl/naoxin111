import request from '@/utils/request';

export const login =(params) => {
	if(params.role == '管理员'){return request({url: '/guanliyuan/login',method: 'post',data: {yonghuming:params.username,mima:params.password},});}
	else if(params.role == '教师'){return request({url: '/jiaoshixinxi/login',method: 'post',data: {gonghao:params.username,mima:params.password},});}
else if(params.role == '学生'){return request({url: '/xueshengxinxi/login',method: 'post',data: {xuehao:params.username,mima:params.password},});}

	
	
}
export const register =(params) => {return request({url: '/xueshengxinxi/register',method: 'post',data: {xuehao:params.username,mima:params.password},})}