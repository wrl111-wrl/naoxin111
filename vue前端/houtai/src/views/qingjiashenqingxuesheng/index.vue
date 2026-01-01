<template>
	<div>
		<!-- 高频请假预警显示区域 -->
		<div v-if="highFrequencyLeaveWarning.length > 0" class="warning-container">
			<el-alert 
				v-for="warning in highFrequencyLeaveWarning" 
				:key="warning.studentId"
				:title="`高频请假预警：个人一周内请假超过3次！`"
				:description="`学生姓名：${warning.studentName}，7天内请假次数：${warning.count}次`"
				type="error" 
				:closable="true"
				@close="handleWarningClose(warning.studentId)"
				show-icon>
			</el-alert>
		</div>
		
		<!-- 扎堆请假预警显示区域 -->
		<div v-if="clusterLeaveWarning.length > 0" class="warning-container">
			<el-alert 
				v-for="warning in clusterLeaveWarning" 
				:key="warning.classId"
				:title="`扎堆请假预警：该班级请假学生人数异常！`"
				:description="`班级：${warning.banji}，3天内请假学生人数：${warning.count}人`"
				type="error" 
				:closable="true"
				@close="handleClusterWarningClose(warning.classId)"
				show-icon>
			</el-alert>
		</div>
		
		<el-form :inline="true" :model="formInline" class="user-search">
			<el-form-item label=""><el-input size="small" v-model="formInline.qingjiabianhao" placeholder="输入请假编号"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.xuehao" placeholder="输入学号"  v-if="userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi'"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.qishishijian" placeholder="输入起始时间"></el-input></el-form-item>
			<el-form-item label=""><el-input size="small" v-model="formInline.zhongzhishijian" placeholder="输入终止时间"></el-input></el-form-item>
			
			<el-form-item>
				<el-button size="small" type="warning" icon="el-icon-search" @click="search">搜索</el-button>
				<el-button size="small" type="primary" icon="el-icon-plus" @click="handleEdit()" v-if="userInfo.roles[0] == 'xuesheng'">添加</el-button>
				<el-button size="small" type="success" icon="el-icon-s-data" @click="daochu()" v-if="userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi'">导出</el-button>
				<el-button size="small" type="danger" icon="el-icon-delete" @click="handleDeleteList()"  v-if="userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi'">批量删除</el-button>
				
			</el-form-item>
			<el-form-item>
				<el-upload class="upload-demo" style="float: left; padding-right: 10px;" action='http://localhost:9999/qingjiashenqing/upload' :headers='headers' :show-file-list='false' :on-success='handleDaoruSuccess' :before-upload='beforeDaoruUpload' ><el-button size="small" type="info" icon="el-icon-sell" v-if="userInfo.roles[0] == 'guanliyuan'">导入</el-button></el-upload>
			</el-form-item>
		</el-form>
		
		<el-table size="small" :data="listData" highlight-current-row v-loading="loading" border element-loading-text="拼命加载中" @selection-change="handleSelectionChange">
			<el-table-column align="center" type="selection" width="60"></el-table-column>
			<el-table-column sortable prop="qingjiabianhao" label="请假编号"></el-table-column>
			<el-table-column sortable prop="xuehao" label="学号"></el-table-column>
			<el-table-column sortable prop="xueshengxingming" label="学生姓名"></el-table-column>
			<el-table-column sortable prop="lianxidianhua" label="联系电话"></el-table-column>
			<el-table-column sortable prop="banji" label="班级"></el-table-column>
			<el-table-column sortable prop="qishishijian" label="起始时间"></el-table-column>
			<el-table-column sortable prop="zhongzhishijian" label="终止时间"></el-table-column>
			<el-table-column sortable prop="issh" label="是否审核"></el-table-column>
			<el-table-column sortable prop="shhf" label="审核回复"></el-table-column>
			
			<el-table-column sortable prop="addtime" label="添加时间" width="160">
				<template slot-scope="scope">
					<div>{{scope.row.addtime|datePipe('yyyy-MM-dd hh:mm:ss')}}</div>
				</template>
			</el-table-column>
			
			<el-table-column align="center" label="操作" min-width="200"> <!-- 宽度适配4个按钮 -->
  <template slot-scope="scope">
    <!-- 外层div实现按钮同行 + 间距控制 -->
    <div style="display: inline-flex; gap: 6px; align-items: center;">
      <!-- 审核按钮：管理员/教师可见，已撤销的申请不显示审核按钮 -->
      <el-button size='mini' type='primary' @click='hsgshenhe(scope.$index, scope.row)' 
                 v-if="(userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi') && scope.row.issh !== '已撤销'">审核</el-button>
      <!-- 编辑按钮：默认全部可见，已审核通过和已撤销的申请禁用 -->
      <el-button size="mini" type="success" @click="handleEdit(scope.$index, scope.row)" 
                 :disabled="scope.row.issh === '已通过' || scope.row.issh === '已撤销'">编辑</el-button>
      <!-- 撤销按钮：仅申请人自己可见且仅可撤销待审核的申请 -->
      <el-button size="mini" type="warning" @click="handleRevoke(scope.$index, scope.row)" 
                 v-if="(userInfo.roles[0] == 'xuesheng' || userInfo.roles[0] == 'jiaoshi') && 
                       ((userInfo.roles[0] == 'xuesheng' && scope.row.xuehao === username) || 
                        (userInfo.roles[0] == 'jiaoshi' && scope.row.xuehao === username)) && 
                       scope.row.issh === '待审核'">撤销</el-button>
      <!-- 删除按钮：仅审批过和已撤销的申请可见，根据角色权限控制 -->
      <el-button size="mini" type="danger" @click="deleteQingjiashenqing(scope.$index, scope.row)" 
                 v-if="(scope.row.issh === '已通过' || scope.row.issh === '未通过' || scope.row.issh === '已撤销') && 
                       ((userInfo.roles[0] == 'xuesheng' && scope.row.xuehao === username) || 
                        (userInfo.roles[0] == 'jiaoshi') ||
                        userInfo.roles[0] == 'guanliyuan')">删除</el-button>
      <!-- 详细按钮：默认全部可见 -->
      <el-button size='mini' type='primary' @click="handleDetail(scope.$index, scope.row)">详细</el-button>
    </div>
  </template>
</el-table-column>
</el-table>
		<Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
		
		<el-dialog :title="title" :visible.sync="editFormVisible" width="30%" @click="closeDialog">
			<el-form label-width="120px" :model="editForm" :rules="rules" ref="editForm">
				<el-form-item  label="请假编号" prop="qingjiabianhao"><el-input size="small" v-model="editForm.qingjiabianhao" auto-complete="off" placeholder="请输入请假编号" style='width:50%'></el-input></el-form-item>
		<el-form-item  label="学号" prop="xuehao"><el-input size="small" v-model="editForm.xuehao" auto-complete="off" placeholder="请输入学号" style='width:50%' disabled></el-input></el-form-item>
		<el-form-item  label="学生姓名" prop="xueshengxingming"><el-input size="small" v-model="editForm.xueshengxingming" auto-complete="off" placeholder="请输入学生姓名" style='width:50%' disabled></el-input></el-form-item>
		<el-form-item  label="联系电话" prop="lianxidianhua"><el-input size="small" v-model="editForm.lianxidianhua" auto-complete="off" placeholder="请输入11位手机号码" style='width:50%'></el-input></el-form-item>
		<el-form-item  label="班级" prop="banji"><el-input size="small" v-model="editForm.banji" auto-complete="off" placeholder="请输入班级" style='width:50%' disabled></el-input></el-form-item>
		<el-form-item  label="请假原因" prop="qingjiayuanyin"><el-input type="textarea" size="small" v-model="editForm.qingjiayuanyin" auto-complete="off" placeholder="请输入请假原因" style='width:100%'></el-input></el-form-item>
		<el-form-item  label="起始时间" prop="qishishijian"><el-date-picker type="datetime" value-format="yyyy-MM-dd HH:mm:ss" size="small" v-model="editForm.qishishijian" style='width:50%'/></el-form-item>
				<el-form-item  label="终止时间" prop="zhongzhishijian"><el-date-picker type="datetime" value-format="yyyy-MM-dd HH:mm:ss" size="small" v-model="editForm.zhongzhishijian" style='width:50%'/></el-form-item>
		<el-form-item  label="备注" prop="beizhu"><el-input type="textarea" size="small" v-model="editForm.beizhu" auto-complete="off" placeholder="请输入备注" style='width:100%'></el-input></el-form-item>
		
				
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeDialog">取消</el-button>
				<el-button size="small" type="primary" :loading="loading" class="title" @click="submitForm('editForm')">保存</el-button>
			</div>
		</el-dialog>
			<el-dialog :title="titleissh" :visible.sync="isshdialog" width="30%" @click="closeisshdialog">
			<el-form label-width="120px" :model="editForm" :rules="rulesissh" ref="editFormissh">
				<el-form-item label="审核状态" prop="shenqingStatus">
					<el-radio v-model="editForm.issh" label="待审核">待审核</el-radio>
					<el-radio v-model="editForm.issh" label="已通过">已通过</el-radio>
					<el-radio v-model="editForm.issh" label="未通过">未通过</el-radio>
				</el-form-item>
				<el-form-item label="审核回复" prop="shhf"><el-input type="textarea" size="small" v-model="editForm.shhf" auto-complete="off" placeholder="请输入审核回复"></el-input></el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeisshdialog">取消</el-button>
				<el-button size="small" type="primary" :loading="loading" class="title" @click="shenhe('editFormissh')">保存</el-button>
			</div>
		</el-dialog>
			
			<el-dialog :title="title" :visible.sync="detailFormVisible" width="60%" @click="closeDialogdetail">
			<table width="100%" border="0"  align="center" cellpadding="3" cellspacing="1" class="table table-striped table-bordered table-hover">
								<tr>
									<td width='11%' height='40px'>请假编号：</td><td width='39%'>{{editForm.qingjiabianhao}}</td>
     <td width='11%' height='40px'>学号：</td><td width='39%'>{{editForm.xuehao}}</td></tr><tr>
     <td width='11%' height='40px'>学生姓名：</td><td width='39%'>{{editForm.xueshengxingming}}</td>
     <td width='11%' height='40px'>联系电话：</td><td width='39%'>{{editForm.lianxidianhua}}</td></tr><tr>
     <td width='11%' height='40px'>班级：</td><td width='39%'>{{editForm.banji}}</td>
     <td width='11%' height='40px'>请假原因：</td><td width='39%'>{{editForm.qingjiayuanyin}}</td></tr><tr>
     <td width='11%' height='40px'>起始时间：</td><td width='39%'>{{editForm.qishishijian}}</td>
     <td width='11%' height='40px'>终止时间：</td><td width='39%'>{{editForm.zhongzhishijian}}</td></tr><tr>
     <td width='11%' height='40px'>备注：</td><td width='39%'>{{editForm.beizhu}}</td>
     <td>&nbsp;</td><td>&nbsp;</td></tr>
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
import { qingjiashenqingList, qingjiashenqingSave, qingjiashenqingDelete,qingjiashenqingEdit,qingjiashenqingDeleteList } from '@/api/qingjiashenqing/qingjiashenqingApi';


import {Session} from "@/utils/storage";
import axios from 'axios';
export default {
	name: 'user',
	data() {
			return {
				loading: false, //是否显示加载
				title: '',
				titleissh: '',
				
				editFormVisible: false, //控制编辑页面显示与隐藏
				payVisible: false,
				tempdingdanxinxi: '',
				id: '',
				radio: '',
				detailFormVisible: false,
				
				isshdialog: false, 
				
				editForm: {
					qingjiabianhao: '',
					xuehao: '',
					xueshengxingming: '',
					lianxidianhua: '',
					banji: '',
					qishishijian: '',
					zhongzhishijian: '',
					issh: '',
					shhf: '',
					qingjiayuanyin: '',
					beizhu: '',
					addtime: ''
				},
				user:[],
				username:'',
				cx:'',
				userInfo: null,
				
				rules: {
					xuehao: [{ required: true, message: '请输入学号', trigger: 'blur' }],
					qingjiayuanyin: [{ required: true, message: '请输入请假原因', trigger: 'blur' }],
					qishishijian: [{ required: true, message: '请选择起始时间', trigger: 'change' }],
					zhongzhishijian: [{ required: true, message: '请选择终止时间', trigger: 'change' }],
					lianxidianhua: [
						{ required: true, message: '请输入联系电话', trigger: 'blur' },
						{ validator: this.validatePhoneNumber, trigger: 'blur' }
					],
					// 统一验证请假原因、起始时间、终止时间不能为空
					validateLeaveFields: [{
						validator: this.validateLeaveRequiredFields, trigger: ['blur', 'change']
					}]
				},
				rulesissh: {shhf: [{ required: true, message: '审核回复不能为空', trigger: 'blur' }],},
				formInline: {
					page: 1,
					limit: 10,
					qingjiabianhao: '',
					xuehao: '',
					banji: '',
					qishishijian: '',
					zhongzhishijian: ''
				},
			
			
			listData: [],
			qingjiashenqings:[],
			highFrequencyLeaveWarning: [],
			clusterLeaveWarning: [],
			
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
			this.username=localStorage.getItem("username") || '';
			this.cx=localStorage.getItem("cx") || '';
			
			// 添加安全检查
			if(this.userInfo && this.userInfo.roles && Array.isArray(this.userInfo.roles) && this.userInfo.roles[0] == 'xuesheng'){
				this.formInline.xuehao = this.username;
			}
			if(this.userInfo && this.userInfo.roles && Array.isArray(this.userInfo.roles) && this.userInfo.roles[0] == 'jiaoshi' && this.userInfo.banji){
				this.formInline.banji = this.userInfo.banji;
			}
			
			// 动态添加时间范围验证规则
			this.$set(this.rules, 'zhongzhishijian', [
				{ required: true, message: '请选择终止时间', trigger: 'change' },
				{ validator: this.validateTimeRange, trigger: 'change' }
			]);

			this.getdata(this.formInline)
		
	},
	methods: {
		
		//zxhifuff
		handleShenheList(){
				const qingjiashenqings = this.qingjiashenqings;
				if(qingjiashenqings.length == 0){
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
						qingjiashenqings.forEach(item=> {
							let data = {...item, issh: 1}
							qingjiashenqingEdit(data).then(res => {})
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
							
							// 处理列表数据中的空值，将null、空字符串或"???"转换为中文提示
							this.listData.forEach(item => {
								Object.keys(item).forEach(key => {
									if (item[key] === null || item[key] === '' || item[key] === '???' || item[key] === '??') {
										item[key] = '未设置';
									}
								});
							});
							
							// 检查高频请假预警
							this.checkHighFrequencyLeaves();
							
							// 检查扎堆请假预警
							this.checkClusterLeaves();
							
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
			// 检查是否允许编辑
			if (row != undefined && row != 'undefined') {
				if (row.issh === '已通过') {
					this.$message({
						type: 'warning',
						message: '该请假申请已审核通过，无法修改'
					});
					return;
				}
				if (row.issh === '已撤销') {
					this.$message({
						type: 'warning',
						message: '该请假申请已撤销，无法修改'
					});
					return;
				}
			}
			
			this.editFormVisible = true
			if (row != undefined && row != 'undefined') {
				this.title = '修改请假申请'
				this.editForm = { ...row };
				
				// 处理空值，将null、空字符串或"???"转换为中文提示
				Object.keys(this.editForm).forEach(key => {
					if (this.editForm[key] === null || this.editForm[key] === '' || this.editForm[key] === '???' || this.editForm[key] === '??') {
						this.editForm[key] = '未设置';
					}
				});
			} else {
				this.title = '添加请假申请'
				this.editForm = {}
				this.editForm.xuehao= this.username;
				this.editForm.xueshengxingming= this.userInfo.xueshengxingming;
				this.editForm.lianxidianhua= this.userInfo.dianhua;
				this.editForm.banji= this.userInfo.banji;
				
				this.editForm.qingjiabianhao = this.getProjectNum() + Math.floor(Math.random() * 10000);
			}
		},
		daochu(){
			axios.get('/qingjiashenqing/getExcel', {
				responseType: 'blob',
				headers: { token: Session.get("token"), 'Content-Type': 'application/x-download' }
			}).then((res) => {
				if (res.status === 200) {
					var a = document.createElement('a')
					var blob = new Blob([res.data], { type: 'application/vnd.ms-excel' })
					var href = window.URL.createObjectURL(blob)
					a.href = href
					a.download = '请假申请.xlsx'
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
		// 统一验证请假原因、起始时间、终止时间不能为空
		validateLeaveRequiredFields(rule, value, callback) {
			const { qingjiayuanyin, qishishijian, zhongzhishijian } = this.editForm;
			
			// 检查任何一个字段为空
			if (!qingjiayuanyin || !qishishijian || !zhongzhishijian) {
				callback(new Error('请假原因/起始时间/终止时间不能为空'));
			} else {
				callback();
			}
		},
		
		// 验证电话号码必须为11位数字
		validatePhoneNumber(rule, value, callback) {
			if (!value) {
				callback();
				return;
			}
			
			// 11位数字验证
			const phoneRegex = /^1[3-9]\d{9}$/;
			if (!phoneRegex.test(value)) {
				callback(new Error('请输入正确的11位手机号码'));
			} else {
				callback();
			}
		},
		
		// 前端验证时间范围
		validateTimeRange(rule, value, callback) {
			if (this.editForm && this.editForm.qishishijian && value) {
				const startTime = new Date(this.editForm.qishishijian);
				const endTime = new Date(value);
				if (startTime >= endTime) {
					callback(new Error('起始时间必须早于终止时间'));
				} else {
					callback();
				}
			} else {
				callback();
			}
		},
		getProjectNum () {
			const projectTime = new Date() // 当前中国标准时间
			const Year = projectTime.getFullYear() // 获取当前年份 支持IE和火狐浏览器.
			const Month = projectTime.getMonth() + 1 // 获取中国区月份
			const Day = projectTime.getDate() // 获取几号
			var CurrentDate = Year
			if (Month >= 10) { // 判断月份和几号是否大于10或者小于10
				CurrentDate += Month
			} else {
				CurrentDate += '0' + Month
			}
			if (Day >= 10) {
				CurrentDate += Day
			} else {
				CurrentDate += '0' + Day
			}
			return CurrentDate
		},
		
		handleDetail: function (index, row) {
			this.detailFormVisible = true
			if (row != undefined && row != 'undefined') {
				this.title = '请假申请详细'
				this.editForm = { ...row };
				
				// 处理空值，将null、空字符串或"???"转换为中文提示
				Object.keys(this.editForm).forEach(key => {
					if (this.editForm[key] === null || this.editForm[key] === '' || this.editForm[key] === '???' || this.editForm[key] === '??') {
						this.editForm[key] = '未设置';
					}
				});
			}
			
		},
		closeDialogdetail() {
				this.getdata(this.formInline)
				this.detailFormVisible = false
			},
		//liangbuedit
		// 编辑、增加页面保存方法
		submitForm(editData) {
			
			// 检查是否允许保存已审核通过的申请
			if (this.editForm.id && this.editForm.issh === '已通过') {
				this.$message({
					type: 'warning',
					message: '该请假申请已审核通过，无法修改'
				});
				return;
			}
			
			this.$refs[editData].validate(valid => {
				if (valid) {
					if(this.editForm.id){
						qingjiashenqingEdit(this.editForm).then(res => {
							this.editFormVisible = false
							
							this.loading = false
							if (res.code == '0') {
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '请假申请修改成功！'
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
						qingjiashenqingSave(this.editForm).then(res => {
							this.editFormVisible = false
							this.loading = false
							if (res.code == '0') {
								
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '请假申请添加成功！'
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
		deleteQingjiashenqing(index, row) {
			this.$confirm('确定要删除吗?', '信息', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				qingjiashenqingDelete(row.id).then(res => {
					if (res.code == '0') {
						this.$message({
								type: 'success',
							message: '请假申请已删除!'
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
		// 撤销请假申请
		handleRevoke(index, row) {
			this.$confirm('确定要撤销该请假申请吗？撤销后将无法恢复。', '信息', {
				confirmButtonText: '确定撤销',
				cancelButtonText: '取消',
				type: 'warning'
			}).then(() => {
				// 撤销操作：将审核状态设置为"已撤销"
				const revokeData = {
					...row,
					issh: '已撤销',
					shhf: '申请人主动撤销'
				};
				
				qingjiashenqingEdit(revokeData).then(res => {
					if (res.code == '0') {
						this.$message({
							type: 'success',
							message: '请假申请已撤销'
						});
						this.getdata(this.formInline);
					} else {
						this.$message({
							type: 'info',
							message: res.msg || '撤销失败，请稍后再试'
						});
					}
				}).catch(err => {
					this.$message.error('撤销失败，请稍后再试');
				});
			}).catch(() => {
				this.$message({
					type: 'info',
					message: '已取消撤销'
				});
			});
		},
		handleSelectionChange(val){
			this.qingjiashenqings = val;
		},
		handleDeleteList(){
			const qingjiashenqings = this.qingjiashenqings;
			if(qingjiashenqings.length == 0){
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
					qingjiashenqingDeleteList(qingjiashenqings).then(res => {
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
		//xuaxnzeshxifou
		hsgshenhe(index,row){
			this.isshdialog = true
			if (row != undefined && row != 'undefined') {
				this.titleissh = '审核'
				this.editForm = { ...row };
				
				// 处理空值，将null、空字符串或"???"转换为中文提示
				Object.keys(this.editForm).forEach(key => {
					if (this.editForm[key] === null || this.editForm[key] === '' || this.editForm[key] === '???' || this.editForm[key] === '??') {
						this.editForm[key] = '未设置';
					}
				});
			} else {
				this.titleissh = '审核'
				this.editForm = {}
			}
			if(this.userInfo.roles[0] == 'user') {
				this.editForm.userId = this.userInfo.id;
			}
			//this.editForm.type = '审核'
		},
		closeisshdialog() {
			this.getdata(this.formInline)
			this.isshdialog = false
		},
		shenhe(editData) {
			this.$refs[editData].validate(valid => {
				if (valid) {
					if(this.editForm.id){
						qingjiashenqingEdit(this.editForm).then(res => {
							this.isshdialog = false
							this.loading = false
							if (res.code == '0') {
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '审核操作成功！'
								})
							} else {
								this.$message({
									type: 'info',
									message: res.msg
								})
							}
						}).catch(err => {
							this.isshdialog = false
							this.loading = false
							this.getdata(this.formInline)
							if(err){
								this.$message.error(err)
							}else {
								this.$message.error('操作失败，请 稍后再试！')
							}
						})
					}else {
						qingjiashenqingSave(this.editForm).then(res => {
							this.isshdialog = false
							this.loading = false
							if (res.code == '0') {
								this.getdata(this.formInline)
								this.$message({
									type: 'success',
									message: '申请添加成功！'
								})
							} else {
								this.$message({
									type: 'info',
									message: res.msg
								})
							}
						}).catch(err => {
							this.isshdialog = false
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
		
		
		
		//youscwexnjiaxn
		// 关闭编辑、增加弹出框
		closeDialog() {
			this.getdata(this.formInline)
			this.editFormVisible = false
		},
		
		// 检查高频请假预警
		checkHighFrequencyLeaves() {
			// 获取7天前的日期
			const sevenDaysAgo = new Date();
			sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
			
			// 按学生分组统计7天内的请假次数
			const studentLeaves = {};
			
			this.listData.forEach(leave => {
				// 跳过已撤销的请假申请
				if (leave.issh === '已撤销') {
					return;
				}
				
				// 获取申请时间（addtime字段）
				const applyDate = new Date(leave.addtime);
				if (applyDate >= sevenDaysAgo) {
					const studentKey = `${leave.xuehao}_${leave.xueshengxingming}`;
					if (!studentLeaves[studentKey]) {
						studentLeaves[studentKey] = {
							studentId: leave.xuehao,
							studentName: leave.xueshengxingming,
							leaves: []
						};
					}
					studentLeaves[studentKey].leaves.push(leave);
				}
			});
			
			// 检查每个学生的请假次数，只为每个学生创建一条预警
			this.highFrequencyLeaveWarning = [];
			for (const studentKey in studentLeaves) {
				const studentData = studentLeaves[studentKey];
				if (studentData.leaves.length >= 3) {
					// 只为该学生创建一条预警信息
					this.highFrequencyLeaveWarning.push({
						studentId: studentData.studentId,
						studentName: studentData.studentName,
						count: studentData.leaves.length
					});
				}
			}
		},
		
		// 处理预警警告关闭事件
		handleWarningClose(studentId) {
			// 从预警数组中移除对应的警告项
			this.highFrequencyLeaveWarning = this.highFrequencyLeaveWarning.filter(warning => 
				warning.studentId !== studentId
			);
		},
		
		// 检查扎堆请假预警
		checkClusterLeaves() {
			// 获取3天前的日期
			const threeDaysAgo = new Date();
			threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
			
			// 按班级分组统计3天内的请假学生人数
			const classLeaves = {};
			
			this.listData.forEach(leave => {
				// 跳过已撤销的请假申请
				if (leave.issh === '已撤销') {
					return;
				}
				
				// 获取申请时间（addtime字段）
				const applyDate = new Date(leave.addtime);
				if (applyDate >= threeDaysAgo) {
					const classKey = leave.banji;
					if (!classLeaves[classKey]) {
						classLeaves[classKey] = {
							classId: classKey,
							banji: leave.banji,
							students: []
						};
					}
					
					// 确保每个学生只统计一次
					const studentKey = `${leave.xuehao}_${leave.xueshengxingming}`;
					if (!classLeaves[classKey].students.includes(studentKey)) {
						classLeaves[classKey].students.push(studentKey);
					}
				}
			});
			
			// 检查每个班级的请假学生人数
			this.clusterLeaveWarning = [];
			for (const classKey in classLeaves) {
				const classData = classLeaves[classKey];
				if (classData.students.length >= 3) {
					this.clusterLeaveWarning.push({
						classId: classData.classId,
						banji: classData.banji,
						count: classData.students.length
					});
				}
			}
		},
		
		handleClusterWarningClose(classId) {
			// 从预警数组中移除对应的警告项
			this.clusterLeaveWarning = this.clusterLeaveWarning.filter(warning => 
				warning.classId !== classId
			);
		}
	},
};
</script>

<style scoped lang="scss">
	@import './index.scss';
	
	// 高频请假预警样式
	.warning-container {
		margin-bottom: 15px;
	}
</style>
