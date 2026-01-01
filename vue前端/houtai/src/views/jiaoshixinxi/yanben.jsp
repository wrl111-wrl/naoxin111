<template>
	<div>
		<el-form :inline="true" :model="formInline" class="user-search">
			<el-form-item label=""><el-input size="small" v-model="formInline.gonghao" placeholder="输入工号"></el-input></el-form-item>			<el-form-item label=""><el-input size="small" v-model="formInline.xingming" placeholder="输入姓名"></el-input></el-form-item>			<el-form-item styxlexulxie4  prop="xingbie"><el-select size="small" v-model="formInline.xingbie" placeholder="请选择性别"><el-option selected label="请选择性别" value=""></el-option><el-option label="男" value="true"></el-option><el-option label="女" value="false"></el-option></el-select></el-form-item>			<el-form-item label=""><el-input size="small" v-model="formInline.shenfenzheng" placeholder="输入身份证"></el-input></el-form-item>			<el-form-item label=""><el-input size="small" v-model="formInline.dianhua" placeholder="输入电话"></el-input></el-form-item>			<el-form-item styxlexulxie8  prop="zhujiaokecheng"><el-select size="small" v-model="formInline.zhujiaokecheng" placeholder="请选择主教课程"><el-option selected label="请选择主教课程" value=""></el-option></el-select></el-form-item>			<el-form-item label=""><el-input size="small" v-model="formInline.jiguan" placeholder="输入籍贯"></el-input></el-form-item>			
			<el-form-item>
				<el-button size="small" type="primary" icon="el-icon-search" @click="search">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-table size="small" :data="listData" highlight-current-row v-loading="loading" border element-loading-text="拼命加载中" @selection-change="handleSelectionChange">
			<el-table-column align="center" type="selection" width="60"></el-table-column>
			<el-table-column sortable prop="gonghao" label="工号"></el-table-column>			<el-table-column sortable prop="xingming" label="姓名"></el-table-column>			<el-table-column align="center" sortable prop="xingbie" label="性别" ><template slot-scope="scope"><div v-if="scope.row.xingbie==1">男</div><div v-else>女</div></template></el-table-column>			<el-table-column sortable prop="shenfenzheng" label="身份证"></el-table-column>			<el-table-column sortable prop="dianhua" label="电话"></el-table-column>			<el-table-column sortable prop="zhicheng" label="职称"></el-table-column>			<el-table-column sortable prop="zhujiaokecheng" label="主教课程"></el-table-column>			<el-table-column sortable prop="banji" label="班级"></el-table-column>			<el-table-column sortable prop="jiguan" label="籍贯"></el-table-column>			<el-table-column align='center' prop='zhaopian' label='照片' width='120'><template slot-scope='scope'><el-image :src='scope.row.zhaopian' style='height:70px'  v-if="scope.row.zhaopian"/><img src="../../../static/images/guanli.jpg" style='height:70px' v-else/></template></el-table-column>			
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
import { jiaoshixinxiList, jiaoshixinxiSave, jiaoshixinxiDelete,jiaoshixinxiEdit,jiaoshixinxiDeleteList } from '@/api/jiaoshixinxi/jiaoshixinxiApi';
import {banjixinxiAllList,banjixinxiList} from "@/api/banjixinxi/banjixinxiApi";				

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
			banjixinxis:[],				
			rules: {
				
			},
			
			formInline: {
				page: 1,
				limit: 10,
			},
			
			
			listData: [],
			jiaoshixinxis:[],
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
		
		this.getdata(this.formInline)
		this.getAllbanjixinxi({});				
	},
	methods: {
		getdata(parameter) {
			jiaoshixinxiList(parameter)
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
		
	
		
		
		getAllbanjixinxi(parameter){banjixinxiList(parameter).then(res=>{if(res.code == '0'){this.banjixinxis = res.data.list}})},				
		
		// 关闭编辑、增加弹出框
		
	},
};
</script>

<style scoped lang="scss">
	@import './index.scss';
</style>
