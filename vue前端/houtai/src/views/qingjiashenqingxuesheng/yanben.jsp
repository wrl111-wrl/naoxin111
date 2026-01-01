<template>
	<div>
		<el-form :inline="true" :model="formInline" class="user-search">
			<el-form-item label=""><el-input size="small" v-model="formInline.qingjiabianhao" placeholder="输入请假编号"></el-input></el-form-item>			<el-form-item label=""><el-input size="small" v-model="formInline.xuehao" placeholder="输入学号"></el-input></el-form-item>			<el-form-item label=""><el-input size="small" v-model="formInline.qishishijian" placeholder="输入起始时间"></el-input></el-form-item>			<el-form-item label=""><el-input size="small" v-model="formInline.zhongzhishijian" placeholder="输入终止时间"></el-input></el-form-item>			
			<el-form-item>
				<el-button size="small" type="primary" icon="el-icon-search" @click="search">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-table size="small" :data="listData" highlight-current-row v-loading="loading" border element-loading-text="拼命加载中" @selection-change="handleSelectionChange">
			<el-table-column align="center" type="selection" width="60"></el-table-column>
			<el-table-column sortable prop="qingjiabianhao" label="请假编号"></el-table-column>			<el-table-column sortable prop="xuehao" label="学号"></el-table-column>			<el-table-column sortable prop="xueshengxingming" label="学生姓名"></el-table-column>			<el-table-column sortable prop="lianxidianhua" label="联系电话"></el-table-column>			<el-table-column sortable prop="banji" label="班级"></el-table-column>			<el-table-column sortable prop="qishishijian" label="起始时间"></el-table-column>			<el-table-column sortable prop="zhongzhishijian" label="终止时间"></el-table-column>			
			<el-table-column sortable prop="addtime" label="添加时间" width="160">
				<template slot-scope="scope">
					<div>{{scope.row.addtime|datePipe('yyyy-MM-dd hh:mm:ss')}}</div>
				</template>
			</el-table-column>
			
			<el-table-column align="center" label="操作" min-width="160">
				<template slot-scope="scope">
					<!--lianjie1-->
				</template>
			</el-table-column>
		</el-table>
		<Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
		
	</div>
</template>

<script>
import Pagination from "@/layout/pagination/Pagination";
import { qingjiashenqingList, qingjiashenqingSave, qingjiashenqingDelete,qingjiashenqingEdit,qingjiashenqingDeleteList } from '@/api/qingjiashenqing/qingjiashenqingApi';


import {Session} from "@/utils/storage";
export default {
	name: 'user',
	data() {
		return {
			loading: false, //是显示加载
			title: '',
			editFormVisible: false, //控制编辑页面显示与隐藏
			
			editForm: {
			},
			user:[],
			username:'',
			cx:'',
			
			rules: {
				
			},
			
			formInline: {
				page: 1,
				limit: 10,
			},
			
			
			listData: [],
			qingjiashenqings:[],
			checkmenu: [],
			pageparm: {
				currentPage: 1,
				pageSize: 10,
				total: 0
			}
		};
	},
	computed:{
		headers(){
			return {"token":Session.get("token")}
		}
	},
	watch: {
			'$route' (to, from) {
				// 路由发生变化页面刷新
				this.$router.go(0);
			}
		},
	components: {
		Pagination
	},
	created() {
		
		if (!Session.get('userInfo')) return false;
		this.userInfo = Session.get('userInfo');
		this.username=localStorage.getItem("username");
		this.cx=localStorage.getItem("cx");
		if(this.userInfo.roles[0] == 'xuesheng'){this.formInline.xuehao= this.username;}		
		this.getdata(this.formInline)
		
	},
	methods: {
		getdata(parameter) {
			qingjiashenqingList(parameter)
					.then(res => {
						this.loading = false
						if (res.success == false) {
							this.$message({
								type: 'info',
								message: res.msg
							})
						} else {
							this.listData = res.data.list
							
							// 分页赋值
							this.pageparm.currentPage = this.formInline.current
							this.pageparm.pageSize = this.formInline.currentNum
							this.pageparm.total = res.data.total
						}
					})
					.catch(err => {
						this.loading = false
						this.$message.error('菜单加载失败，请稍后再试！')
					})
		},
		//qixuzhijixsuan3
		// 分页插件事件
		callFather(parm) {
			this.formInline.current = parm.currentPage
			this.getdata(this.formInline)
		},
		//xia2sui1
		// 搜索事件
		search() {
			this.getdata(this.formInline)
		},
		//显示编辑界面
		
		addSalary(index,row){
				this.$router.push({
					name:'xmkuaixAdd',
					params:{
						id:row.id
					}
				})
			},
		// 编辑、增加页面保存方法
		
		// 删除公司
		
	
		
		
		
		
		// 关闭编辑、增加弹出框
		
	},
};
</script>

<style scoped lang="scss">
	@import './index.scss';
</style>
