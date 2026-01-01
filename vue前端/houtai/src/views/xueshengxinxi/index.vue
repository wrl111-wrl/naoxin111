<template>
	<div>
		<el-form :inline="true" :model="formInline" class="user-search">
			<el-form-item label=""><el-input size="small" v-model="formInline.xuehao" placeholder="输入学号"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.xueshengxingming" placeholder="输入学生姓名"></el-input></el-form-item>
			<el-form-item   prop="xingbie"><el-select size="small" v-model="formInline.xingbie" placeholder="请选择性别"><el-option selected label="请选择性别" value=""></el-option><el-option label="男" value="true"></el-option><el-option label="女" value="false"></el-option></el-select></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.shenfenzheng" placeholder="输入身份证"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.dianhua" placeholder="输入电话"></el-input></el-form-item>
			<el-form-item   prop="banji"><el-select size="small" v-model="formInline.banji" placeholder="请选择班级"><el-option selected label="请选择" value=""></el-option><el-option label="A01" value="A01"></el-option><el-option label="A02" value="A02"></el-option><el-option label="A03" value="A03"></el-option></el-select></el-form-item>
			<el-form-item   prop="jiguan"><el-select size="small" v-model="formInline.jiguan" placeholder="请选择籍贯"><el-option selected label="请选择" value=""></el-option><el-option v-for="province in provinces" :key="province" :label="province" :value="province"></el-option></el-select></el-form-item>
			
			<el-form-item>
				<el-button size="small" type="warning" icon="el-icon-search" @click="search">搜索</el-button>
				<el-button size="small" type="primary" icon="el-icon-plus" @click="handleEdit()" >添加</el-button>
				<el-button size="small" type="success" icon="el-icon-s-data" @click="daochu()" v-if="userInfo.roles[0] == 'guanliyuan'">导出</el-button>
				<el-button size="small" type="danger" icon="el-icon-delete" @click="handleDeleteList()" v-if="userInfo.roles[0] == 'guanliyuan'">批量删除</el-button>
				
			</el-form-item>
			<el-form-item>
				<el-upload class="upload-demo" style="float: left; padding-right: 10px;" action='http://localhost:9999/xueshengxinxi/upload' :headers='headers' :show-file-list='false' :on-success='handleDaoruSuccess' :before-upload='beforeDaoruUpload' ><el-button size="small" type="info" icon="el-icon-sell" v-if="userInfo.roles[0] == 'guanliyuan'">导入</el-button></el-upload>
			</el-form-item>
		</el-form>
		
		<el-table size="small" :data="listData" highlight-current-row v-loading="loading" border element-loading-text="拼命加载中" @selection-change="handleSelectionChange">
			<el-table-column align="center" type="selection" width="60"></el-table-column>
			<el-table-column sortable prop="xuehao" label="学号"></el-table-column>
			<el-table-column sortable prop="xueshengxingming" label="学生姓名"></el-table-column>
			<!-- 修改1：将表格中的性别列改为只显示文字 -->
			<el-table-column align="center" sortable prop="xingbie" label="性别" width="120">
			  <template slot-scope="scope">
				<div style="text-align: center;">
				  {{ scope.row.xingbie ? '男' : '女' }}
				</div>
			  </template>
			</el-table-column>
			<el-table-column sortable prop="shenfenzheng" label="身份证"></el-table-column>
			<el-table-column sortable prop="dianhua" label="电话"></el-table-column>
			<el-table-column sortable prop="banji" label="班级"></el-table-column>
			<el-table-column sortable prop="jiguan" label="籍贯"></el-table-column>
			
			<el-table-column sortable prop="addtime" label="添加时间" width="160">
				<template slot-scope="scope">
					<div>{{scope.row.addtime|datePipe('yyyy-MM-dd hh:mm:ss')}}</div>
				</template>
			</el-table-column>
			
			<el-table-column align="center" label="操作" min-width="160">
			  <template slot-scope="scope">
				<!-- 仅添加外层div实现按钮同行 -->
				<div style="display: inline-flex; gap: 5px;">
				  <el-button size="mini" type="success" @click="handleEdit(scope.$index, scope.row)" v-if="userInfo.roles[0] == 'guanliyuan' ">编辑</el-button>
				  <el-button size="mini" type="danger" @click="deleteXueshengxinxi(scope.$index, scope.row)" v-if="userInfo.roles[0] == 'guanliyuan' ">删除</el-button>
				  <el-button size='mini' type='primary' @click="handleDetail(scope.$index, scope.row)">详细</el-button>
				</div>
			  </template>
			</el-table-column>
		</el-table>
		<Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
		
		<el-dialog :title="title" :visible.sync="editFormVisible" width="30%" @click="closeDialog">
			<el-form label-width="120px" :model="editForm" :rules="rules" ref="editForm">
				<el-form-item  label="学号" prop="xuehao"><el-input size="small" v-model="editForm.xuehao" auto-complete="off" placeholder="请输入学号" style='width:50%'></el-input></el-form-item>
		
		<el-form-item  label="学生姓名" prop="xueshengxingming"><el-input size="small" v-model="editForm.xueshengxingming" auto-complete="off" placeholder="请输入学生姓名" style='width:50%'></el-input></el-form-item>
		<el-form-item label="性别" prop="xingbie">
		  <el-select size="small" v-model="editForm.xingbie" placeholder="请选择性别" style='width:50%'>
		    <el-option selected label="请选择性别" value=""></el-option>
		    <el-option label="男" :value="true"></el-option>
		    <el-option label="女" :value="false"></el-option>
		  </el-select>
		</el-form-item>
		<el-form-item  label="身份证" prop="shenfenzheng"><el-input size="small" v-model="editForm.shenfenzheng" auto-complete="off" placeholder="请输入身份证" style='width:100%'></el-input></el-form-item>
		<el-form-item  label="电话" prop="dianhua"><el-input size="small" v-model="editForm.dianhua" auto-complete="off" placeholder="请输入电话" style='width:50%'></el-input></el-form-item>
		<el-form-item label="班级" prop="banji">
		  <el-select size="small" v-model="editForm.banji" placeholder="请选择班级" style='width:50%'>
		    <el-option selected label="请选择班级" value=""></el-option>
		    <el-option label="A01" value="A01"></el-option>
		    <el-option label="A02" value="A02"></el-option>
		    <el-option label="A03" value="A03"></el-option>
		  </el-select>
		</el-form-item>
		<el-form-item  label="籍贯" prop="jiguan"><el-select size="small" v-model="editForm.jiguan" placeholder="请选择籍贯" style='width:50%'><el-option selected label="请选择" value=""></el-option><el-option v-for="province in provinces" :key="province" :label="province" :value="province"></el-option></el-select></el-form-item>
		<el-form-item  label="备注" prop="beizhu"><el-input type="textarea" size="small" v-model="editForm.beizhu" auto-complete="off" placeholder="请输入备注" style='width:100%'></el-input></el-form-item>
		
				
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeDialog">取消</el-button>
				<el-button size="small" type="primary" :loading="loading" class="title" @click="submitForm('editForm')">保存</el-button>
			</div>
		</el-dialog>
			
			
			<el-dialog :title="title" :visible.sync="detailFormVisible" width="60%" @click="closeDialogdetail">
  <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" class="table table-striped table-bordered table-hover">
    <tr>
      <td width='11%' height=44>学号：</td>
      <td width='39%'>{{editForm.xuehao}}</td>
    </tr>
    <tr>
      <td width='11%' height=44>密码：</td>
      <td width='39%'>{{editForm.mima}}</td>
    </tr>
    <tr>
      <td width='11%' height=44>学生姓名：</td>
      <td width='39%'>{{editForm.xueshengxingming}}</td>
    </tr>
    <tr>
      <td width='11%' height=44>性别：</td>
      <td width='39%'>
        <div>{{ editForm.xingbie ? '男' : '女' }}</div>
      </td>
    </tr>
    <tr>
      <td width='11%' height=44>身份证：</td>
      <td width='39%'>{{editForm.shenfenzheng}}</td>
    </tr>
    <tr>
      <td width='11%' height=44>电话：</td>
      <td width='39%'>{{editForm.dianhua}}</td>
    </tr>
    <tr>
      <td width='11%' height=44>班级：</td>
      <td width='39%'>{{editForm.banji}}</td>
    </tr>
    <tr>
      <td width='11%' height=44>籍贯：</td>
      <td width='39%'>{{editForm.jiguan}}</td>
    </tr>
    <tr>
      <td width='11%' height=100>备注：</td>
      <td width='39%' colspan=1 height=100>{{editForm.beizhu}}</td>
    </tr>
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
import { xueshengxinxiList, xueshengxinxiSave, xueshengxinxiDelete,xueshengxinxiEdit,xueshengxinxiDeleteList } from '@/api/xueshengxinxi/xueshengxinxiApi';
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
			originalForm: {},
			user:[],
			username:'',
			cx:'',
			banjixinxis:[],
				
			rules: {
				xuehao: [{ required: true, message: '请输入学号', trigger: 'blur' },
				{ pattern: /^\d+$/, message: '学号仅支持数字', trigger: 'blur' },
				{ min: 3, max: 3, message: '学号长度为3位', trigger: 'blur' }
				],
				mima: [{ required: true, message: '请输入密码', trigger: 'blur' },
				],
				xueshengxingming: [{ required: true, message: '请输入学生姓名', trigger: 'blur' },
				{ pattern: /^[\u4e00-\u9fa5]+$/, message: '姓名仅支持汉字', trigger: 'blur' },
				{ max: 10, message: '姓名长度不超过10位', trigger: 'blur' }
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
			xueshengxinxis:[],
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
				const xueshengxinxis = this.xueshengxinxis;
				if(xueshengxinxis.length == 0){
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
						xueshengxinxis.forEach(item=> {
							let data = {...item, issh: 1}
							xueshengxinxiEdit(data).then(res => {})
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
			xueshengxinxiList(parameter)
					.then(res => {
						this.loading = false
						if (res.success == false) {
							this.$message({
								type: 'info',
								message: res.msg
							})
						} else {
							this.listData = res.data.list
							
							// 处理列表数据中的空值，将null、空字符串或"???"转换为中文提示
							this.listData.forEach(item => {
								Object.keys(item).forEach(key => {
									if (item[key] === null || item[key] === '' || item[key] === '???' || item[key] === '??') {
										item[key] = '未设置';
									}
								});
							});
							
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
				this.title = '修改学生信息'
				this.editForm = JSON.parse(JSON.stringify(row))
				this.originalForm = JSON.parse(JSON.stringify(row))
			} else {
				this.title = '添加学生信息'
				this.editForm = {
					mima: 'e10adc3949ba59abbe56e057f20f883e' // 默认密码123456的加密值
				}
				this.originalForm = {}
			}
		},
		daochu(){
			axios.get('/xueshengxinxi/getExcel', {
				responseType: 'blob',
				headers: { token: Session.get("token"), 'Content-Type': 'application/x-download' }
			}).then((res) => {
				if (res.status === 200) {
					var a = document.createElement('a')
					var blob = new Blob([res.data], { type: 'application/vnd.ms-excel' })
					var href = window.URL.createObjectURL(blob)
					a.href = href
					a.download = '学生信息.xlsx'
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
		
		handleDetail: function (index, row) {
			this.detailFormVisible = true
			if (row != undefined && row != 'undefined') {
				this.title = '学生信息详细'
				this.editForm = row
			}
			
		},
		closeDialogdetail() {
				this.getdata(this.formInline)
				this.detailFormVisible = false
			},
		// 编辑、增加页面保存方法
		submitForm(editData) {
			
			this.$refs[editData].validate(valid => {
				if (valid) {
					if(this.editForm.id){
						// 比较编辑前后的数据是否有变化
						if(JSON.stringify(this.editForm) === JSON.stringify(this.originalForm)){
							this.$message({
								type: 'info',
								message: '资料未变更'
							})
							return false
						}
						xueshengxinxiEdit(this.editForm).then(res => {
							this.editFormVisible = false
							
							this.loading = false
							if (res.code == '0') {
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '学生信息修改成功！'
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
						xueshengxinxiSave(this.editForm).then(res => {
							this.editFormVisible = false
							this.loading = false
							if (res.code == '0') {
								
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '学生信息添加成功！'
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
				}
			})
		},
		// 删除公司
		deleteXueshengxinxi(index, row) {
			this.$confirm('确定要删除吗?', '信息', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				xueshengxinxiDelete(row.id).then(res => {
					if (res.code == '0') {
						this.$message({
								type: 'success',
							message: '学生信息已删除!'
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
			this.xueshengxinxis = val;
		},
		handleDeleteList(){
			const xueshengxinxis = this.xueshengxinxis;
			if(xueshengxinxis.length == 0){
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
					xueshengxinxiDeleteList(xueshengxinxis).then(res => {
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
		// 移除 editxingbie 方法，因为现在性别不可修改
		
		getAllbanjixinxi(parameter){banjixinxiList(parameter).then(res=>{if(res.code == '0'){this.banjixinxis = res.data.list}})},			
		
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