<template>
	<div>
		<el-form :inline="true" :model="formInline" class="user-search">
			<el-form-item label=""><el-input size="small" v-model="formInline.yonghuming" placeholder="输入用户名"></el-input></el-form-item>
			
			<el-form-item>
				<el-button size="small" type="primary" icon="el-icon-search" @click="search">搜索</el-button>

				<el-button size="small" type="primary" icon="el-icon-plus" @click="handleEdit()" v-if="userInfo.roles[0] == 'guanliyuan'">添加</el-button>
				<el-button size="small" type="danger" icon="el-icon-delete" @click="handleDeleteList()" v-if="userInfo.roles[0] == 'guanliyuan'">批量删除</el-button>
			</el-form-item>
		</el-form>
		<el-table size="small" :data="listData" highlight-current-row v-loading="loading" border element-loading-text="拼命加载中" @selection-change="handleSelectionChange">
			<el-table-column align="center" type="selection" width="60"></el-table-column>
			<el-table-column sortable prop="yonghuming" label="用户名"></el-table-column>
			<el-table-column sortable prop="mima" label="密码"></el-table-column>
			
			<el-table-column sortable prop="addtime" label="添加时间" width="160">
				<template slot-scope="scope">
					<div>{{scope.row.addtime|datePipe('yyyy-MM-dd hh:mm:ss')}}</div>
				</template>
			</el-table-column>
			
			<el-table-column align="center" label="操作" min-width="160">
				<template slot-scope="scope">
					<!--isshfu5-->
<!--					<el-button size="mini" type="success" @click="handleEdit(scope.$index, scope.row)" v-if="userInfo.roles[0] == 'guanliyuan'">编辑</el-button>-->
					<el-button size="mini" type="danger" @click="deleteGuanliyuan(scope.$index, scope.row)" v-if="userInfo.roles[0] == 'guanliyuan'">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
		
		<el-dialog :title="title" :visible.sync="editFormVisible" width="30%" @click="closeDialog">
			<el-form label-width="120px" :model="editForm" :rules="rules" ref="editForm">
				<el-form-item label="用户名" prop="yonghuming"><el-input size="small" v-model="editForm.yonghuming" auto-complete="off" placeholder="请输入用户名" style='width:50%'></el-input></el-form-item>
		<el-form-item label="密码" prop="mima"><el-input size="small" v-model="editForm.mima" auto-complete="off" placeholder="请输入密码" style='width:50%'></el-input></el-form-item>
		
				
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeDialog">取消</el-button>
				<el-button size="small" type="primary" :loading="loading" class="title" @click="submitForm('editForm')">保存</el-button>
			</div>
		</el-dialog>
			
	</div>
</template>

<script>
import Pagination from "@/layout/pagination/Pagination";
import { guanliyuanList, guanliyuanSave, guanliyuanDelete,guanliyuanEdit,guanliyuanDeleteList } from '@/api/guanliyuan/guanliyuanApi';

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
			
			rules: {
				yonghuming: [{ required: true, message: '请输入用户名', trigger: 'blur' },
				],
				mima: [{ required: true, message: '请输入密码', trigger: 'blur' },
				],
				
			},
			
			formInline: {
				page: 1,
				limit: 10,
			},
			
			
			listData: [],
			guanliyuans:[],
			
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
		this.getdata(this.formInline)
		if (!Session.get('userInfo')) return false;
		this.userInfo = Session.get('userInfo');
		
	},
	methods: {
		getdata(parameter) {
			guanliyuanList(parameter)
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
		handleEdit: function (index, row) {
			this.editFormVisible = true
			if (row != undefined && row != 'undefined') {
				this.title = '修改管理员'
				this.editForm = row
			} else {
				this.title = '添加管理员'
				this.editForm = {}
			}
		},
		// 编辑、增加页面保存方法
		submitForm(editData) {
			this.$refs[editData].validate(valid => {
				if (valid) {
					if(this.editForm.id){
						guanliyuanEdit(this.editForm).then(res => {
							this.editFormVisible = false
							this.loading = false
							if (res.code == '0') {
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '管理员修改成功！'
								})
							} else {
								this.$message({
									type: 'info',
									message: res.msg
								})
							}
						}).catch(err => {
							this.editFormVisible = false
							this.loading = false
							this.getdata(this.formInline)
						if(err){
								this.$message.error(err)
							}else {
								this.$message.error('操作失败，请稍后再试！')
							}
						})
					}else {
						guanliyuanSave(this.editForm).then(res => {
							this.editFormVisible = false
							this.loading = false
							if (res.code == '0') {
								
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '管理员添加成功！'
								})
							} else {
								this.$message({
									type: 'info',
									message: res.msg
								})
							}
						}).catch(err => {
							this.editFormVisible = false
							this.loading = false
						if(err){
								this.$message.error(err)
							}else {
								this.$message.error('操作失败，请稍后再试！')
							}
						})
					}
				} else {
					return false
				}
			})
		},
		// 删除公司
		deleteGuanliyuan(index, row) {
			this.$confirm('确定要删除吗?', '信息', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				guanliyuanDelete(row.id).then(res => {
					if (res.code == '0') {
						this.$message({
								type: 'success',
							message: '管理员已删除!'
						})
						this.getdata(this.formInline)
					} else {
						this.$message({
							type: 'info',
							message: res.msg
						})
					}
				}).catch(err => {
					this.loading = false
					this.$message.error('操作失败，请稍后再试')
				})
			}).catch(() => {
				this.$message({
					type: 'info',
					message: '已取消删除'
				})
			})
		},
		handleSelectionChange(val){
			this.guanliyuans = val;
		},
		handleDeleteList(){
			const guanliyuans = this.guanliyuans;
			if(guanliyuans.length == 0){
				this.$message({
					type: 'error',
					message: '请至少选择一项进行删除'
				})
			}else {
				this.$confirm('确定要批量删除吗?', '信息', {
					confirmButtonText: '确定',
					cancelButtonText: '取消',
					type: 'warning'
				}).then(() => {
					guanliyuanDeleteList(guanliyuans).then(res => {
						if (res.code == '0') {
							this.$message({
								type: 'success',
								message: '批量删除成功!'
							})
							this.getdata(this.formInline)
						} else {
							this.$message({
								type: 'info',
								message: res.msg
							})
						}
					}).catch(err => {
						this.loading = false
						this.$message.error('操作失败，请稍后再试')
					})
				}).catch(() => {
					this.$message({
						type: 'info',
						message: '已取消删除'
					})
				})
			}
		},
		
		
		
		// 关闭编辑、增加弹出框
		closeDialog() {
			this.getdata(this.formInline)
			this.editFormVisible = false
		}
	},
};
</script>

<style scoped lang="scss">
	@import './index.scss';
</style>
