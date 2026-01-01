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
			<el-form-item label="起始时间">
				<el-date-picker
					v-model="formInline.qishishijian"
					type="date"
					value-format="yyyy-MM-dd"
					placeholder="选择起始时间"
					size="small"
					style="width: 140px;">
				</el-date-picker>
			</el-form-item>
			<el-form-item label="终止时间">
				<el-date-picker
					v-model="formInline.zhongzhishijian"
					type="date"
					value-format="yyyy-MM-dd"
					placeholder="选择终止时间"
					size="small"
					style="width: 140px;">
				</el-date-picker>
			</el-form-item>
			
			<el-form-item>
				<el-button size="small" type="warning" icon="el-icon-search" @click="search">搜索</el-button>
				<el-button size="small" type="primary" icon="el-icon-plus" @click="handleEdit()" v-if="userInfo.roles[0] == 'xuesheng'">添加</el-button>
				<el-button size="small" type="success" icon="el-icon-s-data" @click="daochu()" v-if="userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi'">导出</el-button>
				<el-button size="small" type="danger" icon="el-icon-delete" @click="handleDeleteList()"  v-if="userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi'">批量删除</el-button>
				<el-button size="small" type="warning" icon="el-icon-error" @click="open()"  v-if="userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi'">开始预警</el-button>
			</el-form-item>
			<el-form-item>
				<el-upload class="upload-demo" style="float: left; padding-right: 10px;" action='http://localhost:8888/qingjiashenqing/upload' :headers='headers' :show-file-list='false' :on-success='handleDaoruSuccess' :before-upload='beforeDaoruUpload' ><el-button size="small" type="info" icon="el-icon-sell" v-if="userInfo.roles[0] == 'guanliyuan'">导入</el-button></el-upload>
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
			<el-table-column label="附件" width="100">
				<template slot-scope="scope">
					<span v-if="scope.row.fujian && scope.row.fujian.trim()">有附件</span>
					<span v-else>无附件</span>
				</template>
			</el-table-column>
			<el-table-column prop="guanlianxuqiu" label="关联需求" width="200">
				<template slot-scope="scope">
					<template v-if="scope.row.guanlianxuqiu && scope.row.guanlianxuqiu.trim()">
						<el-tag 
							v-for="(item, index) in scope.row.guanlianxuqiu.split(',')" 
							:key="index" 
							size="small" 
							type="info"
							style="margin-right: 3px; margin-bottom: 3px;">
							{{item}}
						</el-tag>
					</template>
					<span v-else>无</span>
				</template>
			</el-table-column>
			
			<el-table-column sortable prop="addtime" label="添加时间" width="160">
				<template slot-scope="scope">
					<div>{{scope.row.addtime|datePipe('yyyy-MM-dd hh:mm:ss')}}</div>
				</template>
			</el-table-column>
			
			<el-table-column align="center" label="操作" min-width="200">
				<template slot-scope="scope">
					<div style="display: inline-flex; gap: 6px; align-items: center;">
						<el-button size='mini' type='primary' @click='hsgshenhe(scope.$index, scope.row)' 
							v-if="(userInfo.roles[0] == 'guanliyuan' || userInfo.roles[0] == 'jiaoshi') && scope.row.issh !== '已撤销'">审核</el-button>
						<el-button size="mini" type="success" @click="handleEdit(scope.$index, scope.row)" 
							:disabled="scope.row.issh === '已通过' || scope.row.issh === '已撤销'">编辑</el-button>
						<el-button size="mini" type="warning" @click="handleRevoke(scope.$index, scope.row)" 
							v-if="(userInfo.roles[0] == 'xuesheng' || userInfo.roles[0] == 'jiaoshi') && 
								((userInfo.roles[0] == 'xuesheng' && scope.row.xuehao === xuehao) || 
								(userInfo.roles[0] == 'jiaoshi' && scope.row.xuehao === xuehao)) && 
								scope.row.issh === '待审核'">撤销</el-button>
						<el-button size="mini" type="danger" @click="deleteQingjiashenqing(scope.$index, scope.row)" 
							v-if="(scope.row.issh === '已通过' || scope.row.issh === '未通过' || scope.row.issh === '已撤销') && 
								((userInfo.roles[0] == 'xuesheng' && scope.row.xuehao === xuehao) || 
								(userInfo.roles[0] == 'jiaoshi') ||
								userInfo.roles[0] == 'guanliyuan')">删除</el-button>
						<el-button size='mini' type='primary' @click="handleDetail(scope.$index, scope.row)">详细</el-button>
					</div>
				</template>
			</el-table-column>
		</el-table>
		
		<Pagination v-bind:child-msg="pageparm" @callFather="callFather"></Pagination>
		
		<!-- 编辑对话框 -->
		<el-dialog :title="title" :visible.sync="editFormVisible" width="50%" @click="closeDialog">
			<el-form label-width="120px" :model="editForm" :rules="rules" ref="editForm">
				<el-form-item label="请假编号" prop="qingjiabianhao">
					<el-input size="small" v-model="editForm.qingjiabianhao" auto-complete="off" placeholder="请输入请假编号" style='width:50%'></el-input>
				</el-form-item>
				<el-form-item label="学号" prop="xuehao">
					<el-input size="small" v-model="editForm.xuehao" auto-complete="off" placeholder="请输入学号" style='width:50%' disabled></el-input>
				</el-form-item>
				<el-form-item label="学生姓名" prop="xueshengxingming">
					<el-input size="small" v-model="editForm.xueshengxingming" auto-complete="off" placeholder="请输入学生姓名" style='width:50%' disabled></el-input>
				</el-form-item>
				<el-form-item label="联系电话" prop="lianxidianhua">
					<el-input size="small" v-model="editForm.lianxidianhua" auto-complete="off" placeholder="请输入11位手机号码" style='width:50%'></el-input>
				</el-form-item>
				<el-form-item label="班级" prop="banji">
					<el-input size="small" v-model="editForm.banji" auto-complete="off" placeholder="请输入班级" style='width:50%' disabled></el-input>
				</el-form-item>
				<el-form-item label="请假原因" prop="qingjiayuanyin">
					<el-input type="textarea" size="small" v-model="editForm.qingjiayuanyin" auto-complete="off" placeholder="请输入请假原因，如果是病假建议上传证明文件" style='width:100%'></el-input>
				</el-form-item>
				
				<!-- 关联需求 -->
				<el-form-item label="关联需求" prop="guanlianxuqiu">
					<el-checkbox-group v-model="editForm.guanlianxuqiu" @change="handleGuanlianChange">
						<el-checkbox label="作业延期申请" value="作业延期申请"></el-checkbox>
						<el-checkbox label="实验补做预约" value="实验补做预约"></el-checkbox>
						<el-checkbox label="课程笔记代领" value="课程笔记代领"></el-checkbox>
						<el-checkbox label="课堂录像申请" value="课堂录像申请"></el-checkbox>
						<el-checkbox label="学习资料获取" value="学习资料获取"></el-checkbox>
					</el-checkbox-group>
				</el-form-item>
				
				<!-- 附件上传组件 -->
				<el-form-item label="上传附件" prop="fujian">
					<div class="upload-file">
						<el-upload
							multiple
							:action="uploadFileUrl"
							:before-upload="handleBeforeUpload"
							:file-list="editForm.fileList"
							:limit="5"
							:on-error="handleUploadError"
							:on-exceed="handleExceed"
							:on-success="handleUploadSuccess"
							:on-remove="handleFileRemove"
							:show-file-list="false"
							:headers="headers"
							class="upload-file-uploader"
						>
							<el-button type="primary" size="small" icon="el-icon-upload" plain>上传附件</el-button>
						</el-upload>
						
						<div class="el-upload__tip">
							请上传
							<template v-if="fileSize"> 大小不超过 <b style="color: #f56c6c">{{ fileSize }}MB</b> </template>
							<template v-if="fileType"> 格式为 <b style="color: #f56c6c">{{ fileType.join("/") }}</b> </template>
							的文件（最多5个文件）
						</div>

						<!-- 文件列表展示 -->
						<transition-group class="upload-file-list el-upload-list el-upload-list--text" name="el-fade-in-linear" tag="ul">
							<li :key="file.uid" class="filelistcont" v-for="(file, index) in editForm.fileList">
								<div class="filelistcont-name">
									<span class="el-icon-document"> {{ getFileName(file.name) }} </span>
								</div>
								<div class="ele-upload-list__item-content-action">
									<el-link :underline="false" @click="handleDelete(index)" type="danger">删除</el-link>
								</div>
							</li>
						</transition-group>
					</div>
				</el-form-item>
				
				<el-form-item label="起始时间" prop="qishishijian">
					<el-date-picker type="datetime" value-format="yyyy-MM-dd HH:mm:ss" size="small" v-model="editForm.qishishijian" style='width:50%'/>
				</el-form-item>
				<el-form-item label="终止时间" prop="zhongzhishijian">
					<el-date-picker type="datetime" value-format="yyyy-MM-dd HH:mm:ss" size="small" v-model="editForm.zhongzhishijian" style='width:50%'/>
				</el-form-item>
				<el-form-item label="备注" prop="beizhu">
					<el-input type="textarea" size="small" v-model="editForm.beizhu" auto-complete="off" placeholder="请输入备注" style='width:100%'></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeDialog">取消</el-button>
				<el-button size="small" type="primary" :loading="loading" class="title" @click="submitForm('editForm')">保存</el-button>
			</div>
		</el-dialog>
		
		<!-- 审核对话框 -->
		<el-dialog :title="titleissh" :visible.sync="isshdialog" width="30%" @click="closeisshdialog">
			<el-form label-width="120px" :model="editForm" :rules="rulesissh" ref="editFormissh">
				<el-form-item label="审核状态" prop="shenqingStatus">
					<el-radio v-model="editForm.issh" label="待审核">待审核</el-radio>
					<el-radio v-model="editForm.issh" label="已通过">已通过</el-radio>
					<el-radio v-model="editForm.issh" label="未通过">未通过</el-radio>
				</el-form-item>
				<el-form-item label="审核回复" prop="shhf">
					<el-input type="textarea" size="small" v-model="editForm.shhf" auto-complete="off" placeholder="请输入审核回复"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeisshdialog">取消</el-button>
				<el-button size="small" type="primary" :loading="loading" class="title" @click="shenhe('editFormissh')">保存</el-button>
			</div>
		</el-dialog>
		
		<!-- 详细查看对话框 -->
		<el-dialog :title="title" :visible.sync="detailFormVisible" width="70%" @click="closeDialogdetail">
			<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" class="table table-striped table-bordered table-hover">
				<tr>
					<td width='11%' height='40px'>学号：</td>
					<td width='39%'>{{editForm.xuehao}}</td>
					<td width='11%' height='40px'>学生姓名：</td>
					<td width='39%'>{{editForm.xueshengxingming}}</td>
				</tr>
				<tr>
					<td width='11%' height='40px'>联系电话：</td>
					<td width='39%'>{{editForm.lianxidianhua}}</td>
					<td width='11%' height='40px'>班级：</td>
					<td width='39%'>{{editForm.banji}}</td>
				</tr>
				<tr>
					<td width='11%' height='40px'>请假原因：</td>
					<td colspan="3">{{editForm.qingjiayuanyin}}</td>
				</tr>
				<tr>
					<td width='11%' height='40px'>起始时间：</td>
					<td width='39%'>{{editForm.qishishijian}}</td>
					<td width='11%' height='40px'>终止时间：</td>
					<td width='39%'>{{editForm.zhongzhishijian}}</td>
				</tr>
				<tr v-if="editForm.guanlianxuqiu && editForm.guanlianxuqiu.length > 0">
					<td width='11%' height='40px'>关联需求：</td>
					<td colspan="3">
						<el-tag v-for="(item, index) in editForm.guanlianxuqiu" :key="index" style="margin-right: 5px;">
							{{item}}
						</el-tag>
					</td>
				</tr>
				<tr v-if="editForm.fujian && editForm.fujian.trim()">
					<td width='11%' height='40px'>附件：</td>
					<td colspan="3">
						<el-button size="mini" type="text" @click="viewAttachment">查看附件</el-button>
					</td>
				</tr>
				<tr>
					<td width='11%' height='40px'>备注：</td>
					<td colspan="3">{{editForm.beizhu}}</td>
				</tr>
			</table>
			
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="closeDialogdetail">关闭</el-button>
			</div>
		</el-dialog>
		
		<!-- 附件查看对话框 -->
		<el-dialog title="附件列表" :visible.sync="attachmentDialogVisible" width="60%">
			<div v-if="editForm.fujian && editForm.fujian.trim()">
				<div v-for="(file, index) in attachmentList" :key="index" style="margin-bottom: 15px; padding: 10px; border: 1px solid #ebeef5; border-radius: 4px;">
					<div style="display: flex; align-items: center; justify-content: space-between;">
						<div>
							<i class="el-icon-document" style="font-size: 20px; color: #409EFF; margin-right: 10px;"></i>
							<span>{{file.name}}</span>
						</div>
						<div>
							<el-button size="mini" type="primary" @click="downloadAttachment(file.url, file.name)">下载</el-button>
							<el-button size="mini" type="text" @click="viewFile(file.url)" v-if="isImageFile(file.name)">预览</el-button>
						</div>
					</div>
				</div>
			</div>
			<div v-else>
				<p>暂无附件</p>
			</div>
		</el-dialog>
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
			loading: false,
			title: '',
			titleissh: '',
			editFormVisible: false,
			detailFormVisible: false,
			isshdialog: false,
			attachmentDialogVisible: false,
			
			// 文件上传相关配置
			uploadFileUrl: 'http://localhost:8888/files/upload',
			fileSize: 10, // 文件大小限制（MB）
			fileType: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'], // 允许的文件类型
			attachmentList: [], // 附件列表（用于查看）
			
			editForm: {
				qingjiabianhao: '',
				xuehao: '',
				xueshengxingming: '',
				lianxidianhua: '',
				banji: '',
				qishishijian: '',
				zhongzhishijian: '',
				issh: '待审核',
				shhf: '',
				qingjiayuanyin: '',
				beizhu: '',
				addtime: '',
				fileList: [], // 将fileList移到editForm中
				fujian: '', // 附件路径（多个用逗号分隔）
				fujianyuanname: '', // 附件原文件名（多个用逗号分隔）
				guanlianxuqiu: [] // 关联需求数组
			},
			
			user:[],
			xuehao:'',
			cx:'',
			userInfo: null,
			
			rules: {
				xuehao: [{ required: true, message: '请输入学号', trigger: 'blur' }],
				qingjiayuanyin: [{ required: true, message: '请输入请假原因', trigger: 'blur' }],
				qishishijian: [{ required: true, message: '请选择起始时间', trigger: 'change' },
					{validator: this.validateTimeRange1,trigger: 'change'}
				],
				zhongzhishijian: [
					{ required: true, message: '请选择终止时间', trigger: 'change' },
					{ validator: this.validateTimeRange, trigger: 'change' }
				],
				lianxidianhua: [
					{ required: true, message: '请输入联系电话', trigger: 'blur' },
					{ validator: this.validatePhoneNumber, trigger: 'blur' }
				],
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
			qingjiashenqings: [],
			checkmenu: [],
			highFrequencyLeaveWarning: [],
			clusterLeaveWarning: [],
			pageparm: {
				currentPage: 1,
				pageSize: 10,
				total: 0
			}
		};
	},
	computed: {
		headers() {
			return {"token": Session.get("token")}
		}
	},
	watch: {
		// 监听路由变化
		'$route' (to, from) {
			this.$router.go(0);
		}
	},
	components: {
		Pagination
	},
	created() {
		if (!Session.get('userInfo')) return false;
		this.userInfo = Session.get('userInfo');
		this.xuehao = this.userInfo.xuehao || '';
		this.cx = localStorage.getItem("cx") || '';
		
		// 添加安全检查
		if(this.userInfo && this.userInfo.roles && Array.isArray(this.userInfo.roles) && this.userInfo.roles[0] == 'xuesheng'){
			this.formInline.xuehao = this.xuehao;
		}
		if(this.userInfo && this.userInfo.roles && Array.isArray(this.userInfo.roles) && this.userInfo.roles[0] == 'jiaoshi' && this.userInfo.banji){
			this.formInline.banji = this.userInfo.banji;
		}
		
		this.getdata(this.formInline);
	},
	methods: {
		// 获取文件名
		getFileName(name) {
			if (name.lastIndexOf("/") > -1) {
				return name.slice(name.lastIndexOf("/") + 1);
			} else {
				return name;
			}
		},
		
		// 列表转字符串
		listToString(list, separator) {
			let strs = "";
			separator = separator || ",";
			for (let i in list) {
				if (list[i].url) {
					strs += list[i].url + separator;
				}
			}
			return strs !== '' ? strs.substr(0, strs.length - 1) : '';
		},
		
		// 删除文件
		handleDelete(index) {
			this.editForm.fileList.splice(index, 1);
			this.updateFujianInfo();
		},
		
		// 文件删除处理
		handleFileRemove(file, fileList) {
			this.editForm.fileList = fileList;
			this.updateFujianInfo();
		},
		
		// 更新附件信息到表单
		updateFujianInfo() {
			if (this.editForm.fileList.length > 0) {
				const urls = this.editForm.fileList.map(file => file.url).join(',');
				const names = this.editForm.fileList.map(file => file.name).join(',');
				this.editForm.fujian = urls;
				this.editForm.fujianyuanname = names;
			} else {
				this.editForm.fujian = '';
				this.editForm.fujianyuanname = '';
			}
		},
		
		// 文件上传成功处理
		handleUploadSuccess(res, file) {
			if (res.code == "0") {
				// 获取文件URL
				const fileUrl = "/files/download/" + res.data.id;
				const newFile = {
					uid: new Date().getTime(),
					name: file.name,
					url: fileUrl
				};
				
				this.editForm.fileList.push(newFile);
				this.updateFujianInfo();
				
				this.$message({
					type: 'success',
					message: '文件上传成功!'
				});
			} else {
				this.$message.error(res.msg || '上传失败');
			}
		},
		
		// 超出限制处理
		handleExceed() {
			this.$message.error(`上传文件数量不能超过 5 个!`);
		},
		
		// 上传错误处理
		handleUploadError(err) {
			this.$message.error("上传文件失败");
		},
		
		// 上传前验证
		handleBeforeUpload(file) {
			
			return true;
		},
		
		// 关联需求变化处理
		handleGuanlianChange(val) {
			this.editForm.guanlianxuqiu = val;
		},
		
		// 判断是否为图片文件
		isImageFile(fileName) {
			const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
			return imageExtensions.some(ext => fileName.toLowerCase().endsWith(ext));
		},
		
		// 查看附件
		viewAttachment() {
			if (this.editForm.fujian && this.editForm.fujian.trim()) {
				const urls = this.editForm.fujian.split(',');
				const names = this.editForm.fujianyuanname ? this.editForm.fujianyuanname.split(',') : [];
				
				this.attachmentList = urls.map((url, index) => ({
					name: names[index] || `附件${index + 1}`,
					url: url
				}));
				
				this.attachmentDialogVisible = true;
			}
		},
		
		// 下载附件
		downloadAttachment(url, filename) {
			const link = document.createElement('a');
			link.href = url;
			link.download = filename;
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		},
		
		// 预览文件
		viewFile(url) {
			window.open(url, '_blank');
		},
		
		// 以下是原有方法，保持不变...
		async open() {
			try {
				const response = await axios.get('/qingjiashenqing/error', {
					headers: { 
						token: Session.get("token")
					}
				});
				
				if (response.status === 200) {
					const errorMsg = response.data;
					this.$alert(`一周请假超过三天的有：${errorMsg.msg}`, '预警系统', {
						confirmButtonText: '确定',
						callback: action => {
							this.$message({
								type: 'info',
								message: `action: ${action}`
							});
						}
					});
				}
			} catch (err) {
				console.error('获取预警失败:', err);
				this.$alert('获取预警信息失败', '错误', {
					confirmButtonText: '确定'
				});
			}
		},
		
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
						let filteredList = res.data.list;
						const userRole = this.userInfo?.roles?.[0];
						
						if (userRole && userRole !== 'xuesheng') {
							filteredList = filteredList.filter(item => item.issh !== '已撤销');
						}
						
						this.listData = filteredList;
						
						// 处理列表数据中的空值
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
						
						this.pageparm.currentPage = this.formInline.current
						this.pageparm.pageSize = this.formInline.currentNum
						this.pageparm.total = this.listData.length
					}
				})
				.catch(err => {
					this.loading = false
					this.$message.error('数据加载失败，请稍后再试！')
				})
		},
		
		callFather(parm) {
			this.formInline.current = parm.currentPage
			this.getdata(this.formInline)
		},
		
		search() {
			this.getdata(this.formInline)
		},
		
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
				
				// 初始化fileList
				this.editForm.fileList = [];
				
				// 处理关联需求字段
				if (this.editForm.guanlianxuqiu && typeof this.editForm.guanlianxuqiu === 'string') {
					this.editForm.guanlianxuqiu = this.editForm.guanlianxuqiu.split(',');
				} else if (!this.editForm.guanlianxuqiu) {
					this.editForm.guanlianxuqiu = [];
				}
				
				// 处理附件列表
				if (this.editForm.fujian && this.editForm.fujian.trim()) {
					const urls = this.editForm.fujian.split(',');
					const names = this.editForm.fujianyuanname ? this.editForm.fujianyuanname.split(',') : [];
					
					urls.forEach((url, index) => {
						if (url.trim()) {
							this.editForm.fileList.push({
								uid: new Date().getTime() + index,
								name: names[index] || `文件${index + 1}`,
								url: url
							});
						}
					});
				}
				
				// 处理空值
				Object.keys(this.editForm).forEach(key => {
					if (this.editForm[key] === null || this.editForm[key] === '' || this.editForm[key] === '???' || this.editForm[key] === '??') {
						if (key === 'guanlianxuqiu') {
							this.editForm[key] = [];
						} else if (key === 'fileList') {
							this.editForm[key] = [];
						} else {
							this.editForm[key] = '未设置';
						}
					}
				});
			} else {
				this.title = '添加请假申请'
				this.editForm = {
					qingjiabianhao: '',
					xuehao: this.xuehao,
					xueshengxingming: this.userInfo.xueshengxingming,
					lianxidianhua: this.userInfo.dianhua,
					banji: this.userInfo.banji,
					issh: '待审核',
					shhf: '',
					qingjiayuanyin: '',
					beizhu: '',
					fujian: '',
					fujianyuanname: '',
					fileList: [], // 初始化fileList
					guanlianxuqiu: [] // 初始化关联需求数组
				};
				
				// 生成请假编号
				const now = new Date();
				const year = now.getFullYear();
				const month = (now.getMonth() + 1).toString().padStart(2, '0');
				const day = now.getDate().toString().padStart(2, '0');
				const timestamp = Date.now();
				const sequence = (timestamp % 1000).toString().padStart(3, '0');
				this.editForm.qingjiabianhao = `${year}${month}${day}${sequence}`;
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
		
		// 验证电话号码必须为11位数字
		validatePhoneNumber(rule, value, callback) {
			if (!value) {
				callback();
				return;
			}
			
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
				const today = new Date();
    
    // 转换为只比较年月日（去除时分秒）
    const startDateOnly = new Date(startTime.getFullYear(), startTime.getMonth(), startTime.getDate());
    // const endDateOnly = new Date(endTime.getFullYear(), endTime.getMonth(), endTime.getDate());
    const todayDateOnly = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    
    // 规则1：起始时间必须早于终止时间
    if (startTime >= endTime) {
        return callback(new Error('起始时间必须早于终止时间'));
    }
    
 
   
    
    callback();
			} else {
				callback();
			}
		},
		// 前端验证时间范围
		validateTimeRange1(rule, value, callback) {
			if (this.editForm && this.editForm.qishishijian && value) {
				const startTime = new Date(this.editForm.qishishijian);
				const endTime = new Date(value);
				const today = new Date();
    
    // 转换为只比较年月日（去除时分秒）
    const startDateOnly = new Date(today.getFullYear(), today.getMonth(), today.getDate());

    console.log(startTime,startDateOnly)
    // 规则2：起始时间不能早于今天（申请当天）
    if (startTime <= startDateOnly) {
        return callback(new Error('起始时间不能早于今天'));
    }
   
    
    callback();
			} else {
				callback();
			}
		},
		
		getProjectNum () {
			const projectTime = new Date()
			const Year = projectTime.getFullYear()
			const Month = projectTime.getMonth() + 1
			const Day = projectTime.getDate()
			var CurrentDate = Year
			if (Month >= 10) {
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
				
				// 处理关联需求字段
				if (this.editForm.guanlianxuqiu && typeof this.editForm.guanlianxuqiu === 'string') {
					this.editForm.guanlianxuqiu = this.editForm.guanlianxuqiu.split(',');
				} else if (!this.editForm.guanlianxuqiu) {
					this.editForm.guanlianxuqiu = [];
				}
				
				// 处理空值
				Object.keys(this.editForm).forEach(key => {
					if (this.editForm[key] === null || this.editForm[key] === '' || this.editForm[key] === '???' || this.editForm[key] === '??') {
						if (key === 'guanlianxuqiu') {
							this.editForm[key] = [];
						} else {
							this.editForm[key] = '未设置';
						}
					}
				});
			}
			
		},
		
		closeDialogdetail() {
			this.getdata(this.formInline)
			this.detailFormVisible = false
		},
		
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
					// 处理关联需求数组转字符串
					if (Array.isArray(this.editForm.guanlianxuqiu)) {
						// 过滤掉空值
						const filteredGuanlianxuqiu = this.editForm.guanlianxuqiu.filter(item => item && item.trim());
						this.editForm.guanlianxuqiu = filteredGuanlianxuqiu.length > 0 ? filteredGuanlianxuqiu.join(',') : '';
					}
					
					// 确保为字符串
					if (typeof this.editForm.guanlianxuqiu !== 'string') {
						this.editForm.guanlianxuqiu = '';
					}
					
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
		
		// 删除请假申请
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
		
		hsgshenhe(index,row){
			this.isshdialog = true
			if (row != undefined && row != 'undefined') {
				this.titleissh = '审核'
				this.editForm = { ...row };
				
				// 处理关联需求字段
				if (this.editForm.guanlianxuqiu && typeof this.editForm.guanlianxuqiu === 'string') {
					this.editForm.guanlianxuqiu = this.editForm.guanlianxuqiu.split(',');
				} else if (!this.editForm.guanlianxuqiu) {
					this.editForm.guanlianxuqiu = [];
				}
				
				// 处理空值
				Object.keys(this.editForm).forEach(key => {
					if (this.editForm[key] === null || this.editForm[key] === '' || this.editForm[key] === '???' || this.editForm[key] === '??') {
						if (key === 'guanlianxuqiu') {
							this.editForm[key] = [];
						} else {
							this.editForm[key] = '未设置';
						}
					}
				});
			} else {
				this.titleissh = '审核'
				this.editForm = {}
			}
			if(this.userInfo.roles[0] == 'user') {
				this.editForm.userId = this.userInfo.id;
			}
		},
		
		closeisshdialog() {
			this.getdata(this.formInline)
			this.isshdialog = false
		},
		
		shenhe(editData) {
			this.$refs[editData].validate(valid => {
				if (valid) {
					// 处理关联需求数组转字符串
					if (Array.isArray(this.editForm.guanlianxuqiu)) {
						// 过滤掉空值
						const filteredGuanlianxuqiu = this.editForm.guanlianxuqiu.filter(item => item && item.trim());
						this.editForm.guanlianxuqiu = filteredGuanlianxuqiu.length > 0 ? filteredGuanlianxuqiu.join(',') : '';
					}
					
					// 确保为字符串
					if (typeof this.editForm.guanlianxuqiu !== 'string') {
						this.editForm.guanlianxuqiu = '';
					}
					
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
								this.$message.error('操作失败，请稍后再试！')
							}
						})
					}
				} else {
					return false
				}
			})
		},
		
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
	}
};
</script>

<style scoped lang="scss">
	@import './index.scss';
	
	// 高频请假预警样式
	.warning-container {
		margin-bottom: 15px;
	}
	
	.upload-file {
		.upload-file-uploader {
			margin-bottom: 10px;
		}
		
		.upload-file-list {
			margin-top: 10px;
			max-height: 200px;
			overflow-y: auto;
			
			.filelistcont {
				display: flex;
				align-items: center;
				justify-content: space-between;
				padding: 8px 12px;
				border: 1px solid #ebeef5;
				border-radius: 4px;
				margin-bottom: 5px;
				background-color: #fafafa;
				
				.filelistcont-name {
					flex: 1;
					
					.el-icon-document {
						margin-right: 8px;
						color: #409EFF;
					}
				}
				
				.ele-upload-list__item-content-action {
					flex-shrink: 0;
				}
			}
		}
		
		.el-upload__tip {
			margin-top: 5px;
			color: #909399;
			font-size: 12px;
		}
	}
</style>