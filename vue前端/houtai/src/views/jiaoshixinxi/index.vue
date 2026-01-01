<template>
	<div>
		<el-form :inline="true" :model="formInline" class="user-search">
			<el-form-item label=""><el-input size="small" v-model="formInline.gonghao" placeholder="输入工号"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.xingming" placeholder="输入姓名"></el-input></el-form-item>
			<el-form-item   prop="xingbie"><el-select size="small" v-model="formInline.xingbie" placeholder="请选择性别"><el-option selected label="请选择性别" value=""></el-option><el-option label="男" value="true"></el-option><el-option label="女" value="false"></el-option></el-select></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.shenfenzheng" placeholder="输入身份证"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.dianhua" placeholder="输入电话"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.zhicheng" placeholder="输入职称"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.zhujiaokecheng" placeholder="输入主教课程"></el-input></el-form-item>
			<el-form-item label=""><el-select size="small" v-model="formInline.banji" placeholder="请选择班级"><el-option selected label="请选择班级" value=""></el-option><el-option label="A01" value="A01"></el-option><el-option label="A02" value="A02"></el-option><el-option label="A03" value="A03"></el-option></el-select></el-form-item>
			<el-form-item label=""><el-select size="small" v-model="formInline.jiguan" placeholder="请选择籍贯"><el-option selected label="请选择" value=""></el-option><el-option v-for="province in provinces" :key="province" :label="province" :value="province"></el-option></el-select></el-form-item>
			
			<el-form-item>
				<el-button size="small" type="warning" icon="el-icon-search" @click="search">搜索</el-button>
				<el-button size="small" type="primary" icon="el-icon-plus" @click="handleEdit()" >添加</el-button>
				<el-button size="small" type="success" icon="el-icon-s-data" @click="daochu()" v-if="userInfo.roles[0] == 'guanliyuan'">导出</el-button>
				<el-button size="small" type="danger" icon="el-icon-delete" @click="handleDeleteList()" v-if="userInfo.roles[0] == 'guanliyuan'">批量删除</el-button>
				
			</el-form-item>
			<el-form-item>
				<el-upload class="upload-demo" style="float: left; padding-right: 10px;" action='http://localhost:9999/jiaoshixinxi/upload' :headers='headers' :show-file-list='false' :on-success='handleDaoruSuccess' :before-upload='beforeDaoruUpload' ><el-button size="small" type="info" icon="el-icon-sell" v-if="userInfo.roles[0] == 'guanliyuan'">导入</el-button></el-upload>
			</el-form-item>
		</el-form>
		
		<el-table size="small" :data="listData" highlight-current-row v-loading="loading" border element-loading-text="拼命加载中" @selection-change="handleSelectionChange">
			<el-table-column align="center" type="selection" width="60"></el-table-column>
			<el-table-column sortable prop="gonghao" label="工号"></el-table-column>
			<el-table-column sortable prop="xingming" label="姓名"></el-table-column>
			<el-table-column align="center" sortable prop="xingbie" label="性别" width="120">
			  <template slot-scope="scope">
				<div style="text-align: center;">
				  {{ scope.row.xingbie ? '男' : '女' }}
				</div>
			  </template>
			</el-table-column><el-table-column sortable prop="shenfenzheng" label="身份证"></el-table-column>
			<el-table-column sortable prop="dianhua" label="电话"></el-table-column>
			<el-table-column sortable prop="zhicheng" label="职称"></el-table-column>
			<el-table-column sortable prop="zhujiaokecheng" label="主教课程"></el-table-column>
			<el-table-column sortable prop="banji" label="班级"></el-table-column>
			<el-table-column sortable prop="jiguan" label="籍贯"></el-table-column>
			<el-table-column align='center' prop='zhaopian' label='照片' width='120'><template slot-scope='scope'><el-image :src='scope.row.zhaopian' style='height:70px'  v-if="scope.row.zhaopian"/><img src="../../../static/images/guanli.jpg" style='height:70px' v-else/></template></el-table-column>
			
			<el-table-column sortable prop="addtime" label="添加时间" width="160">
				<template slot-scope="scope">
					<div>{{scope.row.addtime|datePipe('yyyy-MM-dd hh:mm:ss')}}</div>
				</template>
			</el-table-column>
			
			<el-table-column align="center" label="操作" min-width="200">
				<template slot-scope="scope">
					<div style="display: flex; gap: 5px; justify-content: center; flex-wrap: nowrap;">
						<el-button size="mini" type="success" @click="handleEdit(scope.$index, scope.row)" v-if="userInfo.roles[0] == 'guanliyuan' ">编辑</el-button>
						<el-button size="mini" type="danger" @click="deleteJiaoshixinxi(scope.$index, scope.row)" v-if="userInfo.roles[0] == 'guanliyuan' ">删除</el-button>
						<el-button size='mini' type='primary' @click="handleDetail(scope.$index, scope.row)">详细</el-button>
					</div>
				</template>
			</el-table-column>
		</el-table>
		<Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
		
		<el-dialog :title="title" :visible.sync="editFormVisible" width="30%" @click="closeDialog">
			<el-form label-width="120px" :model="editForm" :rules="rules" ref="editForm">
				<el-form-item  label="工号" prop="gonghao"><el-input size="small" v-model="editForm.gonghao" auto-complete="off" placeholder="请输入工号" style='width:50%'></el-input></el-form-item>
		
		<el-form-item  label="姓名" prop="xingming"><el-input size="small" v-model="editForm.xingming" auto-complete="off" placeholder="请输入姓名" style='width:50%'></el-input></el-form-item>
		<el-form-item  label="性别" prop="xingbie"><el-radio v-model="editForm.xingbie" :label=true>男</el-radio><el-radio v-model="editForm.xingbie" :label=false>女</el-radio></el-form-item>
		<el-form-item  label="身份证" prop="shenfenzheng"><el-input size="small" v-model="editForm.shenfenzheng" auto-complete="off" placeholder="请输入身份证" style='width:100%'></el-input></el-form-item>
		<el-form-item  label="电话" prop="dianhua"><el-input size="small" v-model="editForm.dianhua" auto-complete="off" placeholder="请输入电话" style='width:50%'></el-input></el-form-item>
		<el-form-item  label="职称" prop="zhicheng"><el-input size="small" v-model="editForm.zhicheng" auto-complete="off" placeholder="请输入职称" style='width:50%'></el-input></el-form-item>
		<el-form-item  label="主教课程" prop="zhujiaokecheng"><el-input size="small" v-model="editForm.zhujiaokecheng" auto-complete="off" placeholder="请输入职称" style='width:50%'></el-input></el-form-item>
		<el-form-item  label='班级' prop="banji"><el-select size="small" v-model="editForm.banji" placeholder="请选择"><el-option selected label="请选择" value=""></el-option><el-option v-for="item in banjixinxis" :key="item.banji" :label="item.banji" :value="item.banji"></el-option></el-select></el-form-item>
		<el-form-item  label="籍贯" prop="jiguan"><el-select size="small" v-model="editForm.jiguan" placeholder="请选择籍贯"><el-option selected label="请选择" value=""></el-option><el-option v-for="province in provinces" :key="province" :label="province" :value="province"></el-option></el-select></el-form-item>
		<el-form-item  label='照片' prop='zhaopian'><el-upload class='avatar-uploader' action='http://localhost:9999/files/upload' :headers='headers' :show-file-list='false' :on-success='handleZhaopianSuccess' :before-upload='beforeZhaopianUpload'><img v-if='editForm.zhaopian' :src='editForm.zhaopian' class='avatar'><i v-else class='el-icon-plus avatar-uploader-icon'></i></el-upload></el-form-item>
		<el-form-item  label="备注" prop="beizhu"><el-input type="textarea" size="small" v-model="editForm.beizhu" auto-complete="off" placeholder="请输入备注" style='width:100%'></el-input></el-form-item>
		
				
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeDialog">取消</el-button>
				<el-button size="small" type="primary" :loading="loading" class="title" @click="submitForm('editForm')">保存</el-button>
			</div>
		</el-dialog>
			
			
			<el-dialog :title="title" :visible.sync="detailFormVisible" width="60%" @click="closeDialogdetail">
			<table width="100%" border="0"  align="center" cellpadding="3" cellspacing="1" class="table table-striped table-bordered table-hover">
								<tr>
									<td width='11%' height=44>工号：</td><td width='39%'>{{editForm.gonghao}}</td>
<td  rowspan=10 align=center><el-upload class='avatar-uploader'  :headers='headers' :show-file-list='false'  ><img v-if='editForm.zhaopian' :src='editForm.zhaopian' class='avatar'><i v-else class='el-icon-plus avatar-uploader-icon'></i></el-upload></td></tr><tr>
<td width='11%' height=44>密码：</td><td width='39%'>{{editForm.mima}}</td>
</tr><tr>
<td width='11%' height=44>姓名：</td><td width='39%'>{{editForm.xingming}}</td>
</tr><tr>
<td width='11%' height=44>性别：</td><td width='39%'><div v-if="editForm.xingbie==1">男</div><div v-else>女</div></td>
</tr><tr>
<td width='11%' height=44>身份证：</td><td width='39%'>{{editForm.shenfenzheng}}</td>
</tr><tr>
<td width='11%' height=44>电话：</td><td width='39%'>{{editForm.dianhua}}</td>
</tr><tr>
<td width='11%' height=44>职称：</td><td width='39%'>{{editForm.zhicheng}}</td>
</tr><tr>
<td width='11%' height=44>主教课程：</td><td width='39%'>{{editForm.zhujiaokecheng}}</td>
</tr><tr>
<td width='11%' height=44>班级：</td><td width='39%'>{{editForm.banji}}</td>
</tr><tr>
<td width='11%' height=44>籍贯：</td><td width='39%'>{{editForm.jiguan}}</td>
</tr><tr>


<td width='11%' height=100  >备注：</td><td width='39%' colspan=2 height=100 >{{editForm.beizhu}}</td></tr>
							</table>
			


			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeDialogdetail">关闭</el-button>

			</div>
		</el-dialog>
			<!--zhixfudhk-->
	</div>
</template>

<script>
import Pagination from "@/layout/pagination/Pagination";
import { jiaoshixinxiList, jiaoshixinxiSave, jiaoshixinxiDelete,jiaoshixinxiEdit,jiaoshixinxiDeleteList } from '@/api/jiaoshixinxi/jiaoshixinxiApi';
import {banjixinxiAllList,banjixinxiList} from "@/api/banjixinxi/banjixinxiApi";
import { provinces } from '@/utils/provinces';
				

import {Session} from "@/utils/storage";
import axios from 'axios';
export default {
	name: 'user',
	data() {
		return {
			loading: false, //是显示加载
			title: '',
			
			editFormVisible: false, //控制编辑页面显示与隐藏
			payVisible: false,
			tempdingdanxinxi: '',
			id: '',
			radio: '',
			detailFormVisible: false,
			
			
			
			editForm: {
			},
			user:[],
			username:'',
			cx:'',
			banjixinxis:[],
				
			rules: {
				gonghao: [{ required: true, message: '请输入工号', trigger: 'blur' },
				],
				mima: [{ required: true, message: '请输入密码', trigger: 'blur' },
				],
				xingming: [{ required: true, message: '请输入姓名', trigger: 'blur' },
				],
				shenfenzheng: [{ required: true, message: '请输入身份证', trigger: 'blur' },
				{ pattern:/^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/,required: true,message: '请输入正确身份证号',trigger: 'blur'}
				],
				dianhua: [{ required: true, message: '请输入电话', trigger: 'blur' },
				{ pattern: /^[1][3,4,5,7,8][0-9]{9}$/,required: true,message: '请输入正确的手机号',trigger: 'blur'}
				],
				
			},
			
			formInline: {
				page: 1,
				limit: 10,
			},
			
			
			listData: [],
			jiaoshixinxis:[],
			provinces: provinces,
			
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
		
		//zxhifuff
		handleShenheList(){
				const jiaoshixinxis = this.jiaoshixinxis;
				if(jiaoshixinxis.length == 0){
					this.$message({
						type: 'error',
						message: '请至少选择一项'
					})
				}else {
					this.$confirm('确定要批量审核吗?', '信息', {
						confirmButtonText: '确定',
						cancelButtonText: '取消',
						type: 'warning'
					}).then(() => {
						jiaoshixinxis.forEach(item=> {
							let data = {...item, issh: 1}
							jiaoshixinxiEdit(data).then(res => {})
						})
						this.getdata(this.formInline)
						this.$message({
							type: 'success',
							message: '批量审核成功！'
						})
					}).catch(() => {
						this.$message({
							type: 'info',
							message: '已取消批量审核'
						})
					})
				}
			},
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
		
		// 分页插件事件
		callFather(parm) {
			this.formInline.current = parm.currentPage
			this.getdata(this.formInline)
		},
		
		// 搜索事件
		search() {
			this.getdata(this.formInline)
		},
		//显示编辑界面
		handleEdit: function (index, row) {
			this.editFormVisible = true
			if (row != undefined && row != 'undefined') {
				this.title = '修改教师信息'
				this.editForm = row
			} else {
				this.title = '添加教师信息'
				this.editForm = {
					mima: 'e10adc3949ba59abbe56e057f20f883e' // 默认密码123456的加密值
				}
				
				
				//zixdonxgbianxhao1
			}
		},
		daochu(){
			axios.get('/jiaoshixinxi/getExcel', {
				responseType: 'blob',
				headers: { token: Session.get("token"), 'Content-Type': 'application/x-download' }
			}).then((res) => {
				if (res.status === 200) {
					var a = document.createElement('a')
					var blob = new Blob([res.data], { type: 'application/vnd.ms-excel' })
					var href = window.URL.createObjectURL(blob)
					a.href = href
					a.download = '教师信息.xlsx'
					document.body.appendChild(a)
					a.click() 
					document.body.removeChild(a) 
					window.URL.revokeObjectURL(href)
				}
			}).catch((err) => {
				console.log(err)
			})
		},
		handleDaoruSuccess(res, file) {
				if(res.code == "0") {
					this.$message({
						type: 'success',
						message: '导入成功!'
					})
					this.getdata(this.formInline);
				}
			},
		beforeDaoruUpload(file) {
			const isJPG = file.type === 'application/vnd.ms-excel';
			if (!isJPG) {
				this.$message.error('上传只能是 excel 格式!');
			}
			return isJPG;
		},
		//zixdonxgbianxhao2
		
		handleDetail: function (index, row) {
			this.detailFormVisible = true
			if (row != undefined && row != 'undefined') {
				this.title = '教师信息详细'
				this.editForm = row
			}
			
		},
		closeDialogdetail() {
				this.getdata(this.formInline)
				this.detailFormVisible = false
			},
		//liangbuedit
		// 编辑、增加页面保存方法
		submitForm(editData) {
			
			this.$refs[editData].validate(valid => {
				if (valid) {
					if(this.editForm.id){
						jiaoshixinxiEdit(this.editForm).then(res => {
							this.editFormVisible = false
							
							this.loading = false
							if (res.code == '0') {
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '教师信息修改成功！'
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
						jiaoshixinxiSave(this.editForm).then(res => {
							this.editFormVisible = false
							this.loading = false
							if (res.code == '0') {
								
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '教师信息添加成功！'
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
		deleteJiaoshixinxi(index, row) {
			this.$confirm('确定要删除吗?', '信息', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				jiaoshixinxiDelete(row.id).then(res => {
					if (res.code == '0') {
						this.$message({
								type: 'success',
							message: '教师信息已删除!'
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
			this.jiaoshixinxis = val;
		},
		handleDeleteList(){
			const jiaoshixinxis = this.jiaoshixinxis;
			if(jiaoshixinxis.length == 0){
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
					jiaoshixinxiDeleteList(jiaoshixinxis).then(res => {
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
		editxingbie(index,row){
			let data = {...row,xingbie:!row.xingbie}
			jiaoshixinxiEdit(data).then(res => {
				this.editFormVisible = false
				this.loading = false
				if (res.code == '0') {
					this.getdata(this.formInline)
					this.$message({
						type: 'success',
						message: '性别修改成功！'
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
		},
		//xuaxnzeshxifou
		
		
		getAllbanjixinxi(parameter){banjixinxiList(parameter).then(res=>{if(res.code == '0'){this.banjixinxis = res.data.list}})},
				
		handleZhaopianSuccess(res, file) {
				if(res.code == "0") {
					this.editForm.zhaopian = "/files/download/"+res.data.id
				}
			},
			beforeZhaopianUpload(file) {
				const isJPG = file.type === 'image/jpeg';
				const isLt2M = file.size / 1024 / 1024 < 2;

				if (!isJPG) {
					this.$message.error('上传图片只能是 JPG 格式!');
				}
				if (!isLt2M) {
					this.$message.error('上传图片大小不能超过 2MB!');
				}
				return isJPG && isLt2M;
			},
				
		//youscwexnjiaxn
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
