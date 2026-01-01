﻿<template>
	<div style="position: fixed;top: 50%;left: 50%;transform: translate(-50%, -50%);width: 400px;background-color: rgba(255,255,255,0.95);padding: 30px;border-radius: 10px;box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
		<div v-if="isLocked" style="text-align: center; color: #f56c6c; font-size: 18px;">
			<i class="el-icon-lock"></i>
			<p>原密码多次错误，修改密码功能已锁定</p>
			<!-- <p>剩余锁定时间：{{ countdownMinutes }}分{{ countdownSeconds }}秒</p> -->
		</div>
		<div v-else>
			<h3 style="text-align: center; margin: 0 0 20px 0; color: #303133;">修改密码</h3>
			<el-form :model="editForm" :rules="rules" ref="editForm">
				<el-form-item label="原密码" prop="password">
					<el-input size="small" v-model="editForm.password" show-password auto-complete="off" placeholder="请输入原密码" style="width: 100%;"></el-input>
					<!-- 密码错误提示 -->
					<div v-if="passwordError" style="color: #f56c6c; font-size: 12px; margin-top: 5px;">
						{{ passwordErrorMessage }}
					</div>
				</el-form-item>
				<el-form-item label="新密码" prop="newPassword">
					<el-input size="small" v-model="editForm.newPassword" show-password auto-complete="off" placeholder="新密码（6位）" style="width: 100%;"></el-input>
				</el-form-item>
				<el-form-item label="确认密码" prop="newPassword2">
					<el-input size="small" v-model="editForm.newPassword2" show-password auto-complete="off" placeholder="重复新密码" style="width: 100%;"></el-input>
				</el-form-item>
				<el-form-item>
					<div style="text-align: center; width: 100%;">
						<el-button size="small" type="primary" :loading="loading" :disabled="isLocked" @click="submitForm('editForm')" style="width: 120px; margin-bottom: 10px;">
							{{ isLocked ? '已锁定' : '修改密码' }}
						</el-button>
						<div v-if="errorCount > 0" style="color: #f56c6c; font-size: 12px;">
							错误 {{ errorCount }}/3 次
						</div>
					</div>
				</el-form-item>
			</el-form>
			<div style="margin-top: 15px; font-size: 12px; color: #909399; text-align: center;">
				密码要求：6位字符，包含字母、数字、特殊字符中的任意组合，不能有空格
			</div>
		</div>
	</div>
</template>

<script>
	import Pagination from "@/layout/pagination/Pagination";
	import {Session} from "@/utils/storage";
	import {jiaoshixinxiUpdatePassword} from "@/api/jiaoshixinxi/jiaoshixinxiApi";
	import {xueshengxinxiUpdatePassword} from "@/api/xueshengxinxi/xueshengxinxiApi";
	import {guanliyuanUpdatePassword} from "@/api/guanliyuan/guanliyuanApi";
	
	// 全局Map，存储所有用户的密码错误信息
	const globalPasswordMap = new Map();
	
	export default {
		name: 'user',
		data() {
			return {
				loading: false,
				title: '',
				editFormVisible: false,
				editForm: {},
				user:[],
				userInfo: null,
				
				// 当前用户的错误计数和锁定状态
				errorCount: 0,
				isLocked: false,
				lockoutEndTime: null,
				countdownMinutes: 10,
				countdownSeconds: 0,
				countdownTimer: null,
				
				// 密码错误提示
				passwordError: false,
				passwordErrorMessage: '',
				
				// rules表单验证
				rules: {
					password: [
						{ required: true, message: '请输入原密码', trigger: 'blur' }
					],
					newPassword: [
						{ required: true, message: '请输入新密码', trigger: 'blur' },
						{ pattern: /^\S{6}$/, message: '密码必须为6位字符且不能包含空格', trigger: 'blur' },
						{ validator: this.validatePasswordComplexity, message: '密码必须包含字母、数字或特殊字符中的任意组合', trigger: 'blur' },
						{ validator: this.validatePasswordDifferent, message: '新旧密码不能一致', trigger: 'blur' }
					],
					newPassword2: [
						{ required: true, message: '请输入新密码', trigger: 'blur' },
						{ pattern: /^\S{6}$/, message: '密码必须为6位字符且不能包含空格', trigger: 'blur' },
						{ validator: this.validatePasswordComplexity, message: '密码必须包含字母、数字或特殊字符中的任意组合', trigger: 'blur' },
						{ validator: this.validatePasswordDifferent, message: '新旧密码不能一致', trigger: 'blur' }
					],
				},
				
				formInline: {
					page: 1,
					limit: 10,
				},
				listData: [],
				checkmenu: [],
				pageparm: {
					currentPage: 1,
					pageSize: 10,
					total: 0
				}
			};
		},
		created() {
			// 获取当前用户信息
			this.userInfo = Session.get('userInfo');
			console.log('修改密码界面创建时用户信息:', this.userInfo);
			
			// 组件创建时检查当前用户的锁定状态
			this.checkCurrentUserLockoutStatus();
		},
		beforeDestroy() {
			// 组件销毁时清除定时器
			this.clearCountdownTimer();
		},
		methods: {
			// 获取当前用户的用户ID
			getCurrentUserId() {
				if (!this.userInfo || !this.userInfo.id) {
					this.userInfo = Session.get('userInfo');
				}
				if (!this.userInfo || !this.userInfo.id) {
					console.warn('无法获取当前用户ID，使用默认值');
					return 'unknown';
				}
				// 使用用户ID和角色组合作为唯一标识
				const role = this.userInfo.roles ? this.userInfo.roles[0] : 'unknown';
				return `${role}_${this.userInfo.id}`;
			},
			
			// 从全局Map中获取当前用户的数据
			getCurrentUserData() {
				const userId = this.getCurrentUserId();
				return globalPasswordMap.get(userId) || { 
					errorCount: 0, 
					lockoutEndTime: null 
				};
			},
			
			// 保存当前用户数据到全局Map
			saveCurrentUserData(data) {
				const userId = this.getCurrentUserId();
				globalPasswordMap.set(userId, data);
				console.log('保存用户密码数据到Map:', userId, data);
			},
			
			// 清理过期用户数据（可选）
			cleanExpiredUserData() {
				const now = Date.now();
				for (const [userId, data] of globalPasswordMap.entries()) {
					if (data.lockoutEndTime && data.lockoutEndTime < now) {
						// 锁定时间已过，清理数据
						globalPasswordMap.delete(userId);
					}
				}
			},
			
			// 密码复杂度验证
			validatePasswordComplexity(rule, value, callback) {
				if (!value) {
					callback();
					return;
				}
				
				const hasLetter = /[a-zA-Z]/.test(value);
				const hasNumber = /[0-9]/.test(value);
				const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(value);
				
				if (!hasLetter && !hasNumber && !hasSpecial) {
					callback(new Error('密码必须包含字母、数字或特殊字符中的任意组合'));
				} else {
					callback();
				}
			},
			
			// 新密码与旧密码不能一致验证
			validatePasswordDifferent(rule, value, callback) {
				if (!value) {
					callback();
					return;
				}
				
				const oldPassword = this.editForm.password;
				if (oldPassword && value === oldPassword) {
					callback(new Error('新旧密码不能一致'));
				} else {
					callback();
				}
			},
			
			// 清除倒计时定时器
			clearCountdownTimer() {
				if (this.countdownTimer) {
					clearInterval(this.countdownTimer);
					this.countdownTimer = null;
				}
			},
			
			// 启动锁定倒计时
			startLockoutCountdown() {
				const lockoutDuration = 10 * 60 * 1000; // 10分钟
				this.lockoutEndTime = Date.now() + lockoutDuration;
				this.isLocked = true;
				
				// 保存到Map
				this.saveCurrentUserData({
					errorCount: this.errorCount,
					lockoutEndTime: this.lockoutEndTime
				});
				
				// 启动倒计时
				this.countdownTimer = setInterval(() => {
					const now = Date.now();
					const timeLeft = this.lockoutEndTime - now;
					
					if (timeLeft <= 0) {
						this.clearCurrentUserLockout();
					} else {
						this.countdownMinutes = Math.floor(timeLeft / (60 * 1000));
						this.countdownSeconds = Math.floor((timeLeft % (60 * 1000)) / 1000);
					}
				}, 1000);
			},
			
			// 清除当前用户的锁定状态
			clearCurrentUserLockout() {
				const userId = this.getCurrentUserId();
				
				this.isLocked = false;
				this.errorCount = 0;
				this.lockoutEndTime = null;
				this.countdownMinutes = 10;
				this.countdownSeconds = 0;
				
				this.clearCountdownTimer();
				
				// 从Map中删除用户数据
				globalPasswordMap.delete(userId);
				console.log('清除用户锁定状态:', userId);
			},
			
			// 检查当前用户是否被锁定
			checkCurrentUserLockoutStatus() {
				const userData = this.getCurrentUserData();
				
				if (!userData) {
					this.isLocked = false;
					this.errorCount = 0;
					return false;
				}
				
				// 设置错误计数
				this.errorCount = userData.errorCount || 0;
				
				// 检查是否被锁定
				if (userData.lockoutEndTime) {
					const now = Date.now();
					
					if (now < userData.lockoutEndTime) {
						// 还在锁定时间内
						this.isLocked = true;
						this.lockoutEndTime = userData.lockoutEndTime;
						this.startLockoutCountdown();
						return true;
					} else {
						// 锁定时间已过，清除状态
						this.clearCurrentUserLockout();
					}
				}
				
				return false;
			},
			
			// 增加错误计数
			incrementErrorCount() {
				this.errorCount++;
				console.log('当前用户错误计数:', this.getCurrentUserId(), this.errorCount);
			},
			
			// 保存当前用户错误计数到Map
			saveCurrentUserErrorCount() {
				const userId = this.getCurrentUserId();
				const userData = this.getCurrentUserData();
				
				userData.errorCount = this.errorCount;
				globalPasswordMap.set(userId, userData);
				
				console.log('保存用户错误计数到Map:', userId, userData);
			},
			
			// 清除当前用户错误计数
			clearCurrentUserErrorCount() {
				const userId = this.getCurrentUserId();
				const userData = this.getCurrentUserData();
				
				userData.errorCount = 0;
				globalPasswordMap.set(userId, userData);
				
				this.errorCount = 0;
				console.log('清除用户错误计数:', userId);
			},
			
			// 编辑、增加页面保存方法
			submitForm: function (editData) {
				console.log('submitForm - 当前用户信息:', this.userInfo);
				
				// 检查是否被锁定
				if (this.checkCurrentUserLockoutStatus()) {
					this.$message.warning('修改密码功能已锁定，请稍后再试');
					return;
				}
				
				// 重置密码错误提示
				this.passwordError = false;
				this.passwordErrorMessage = '';
				
				this.$refs[editData].validate(valid => {
					if (valid) {
						if (this.editForm.newPassword === this.editForm.newPassword2) {
							// 确保获取到最新的用户信息
							if (!this.userInfo || !this.userInfo.id) {
								this.userInfo = Session.get('userInfo');
								console.log('submitForm - 重新获取的用户信息:', this.userInfo);
							}
							
							// 设置用户ID到表单
							if (this.userInfo && this.userInfo.id) {
								this.editForm.id = this.userInfo.id;
								console.log('submitForm - 设置的用户ID:', this.editForm.id);
							} else {
								console.error('submitForm - 无法获取用户ID');
								this.$message.error('无法获取用户信息，请重新登录');
								return;
							}
							
							this.loading = true;
							
							// 根据角色调用不同的API
							const role = this.userInfo.roles ? this.userInfo.roles[0] : '';
							let apiPromise;
							
							switch(role) {
								case 'guanliyuan':
									apiPromise = guanliyuanUpdatePassword(this.editForm);
									break;
								case 'jiaoshi':
									apiPromise = jiaoshixinxiUpdatePassword(this.editForm);
									break;
								case 'xuesheng':
									apiPromise = xueshengxinxiUpdatePassword(this.editForm);
									break;
								default:
									this.$message.error('未知用户角色');
									this.loading = false;
									return;
							}
							
							apiPromise.then(res => {
								this.loading = false;
								
								if (res.code == "0") {
									// 修改成功
									this.$message.success('修改成功，为了安全，系统将自动清空session，请您重新登陆');
									
									// 清除当前用户的错误计数
									this.clearCurrentUserErrorCount();
									
									setTimeout(() => {
										Session.clear();
										window.location.reload();
									}, 2000);
								} else {
									// 原密码错误，增加错误计数
									this.handlePasswordError(res.msg || '原密码错误');
								}
							}).catch(err => {
								this.loading = false;
								// 网络错误或其他错误，增加错误计数
								this.handlePasswordError('原密码错误，请重新输入');
							});
							
						} else {
							this.$message({
								type: 'error',
								message: '两次密码输入不一致'
							});
						}
					} else {
						return false;
					}
				});
			},
			
			// 处理密码错误
			handlePasswordError(message = '原密码错误') {
				console.log('处理密码错误，当前用户ID:', this.getCurrentUserId());
				
				// 增加错误计数
				this.incrementErrorCount();
				
				// 保存错误计数到Map
				this.saveCurrentUserErrorCount();
				
				// 设置密码错误提示
				this.passwordError = true;
				
				if (this.errorCount >= 3) {
					// 达到3次错误，启动锁定机制
					this.startLockoutCountdown();
					this.passwordErrorMessage = '原密码多次错误，请10分钟后再试';
				} else {
					const remaining = 3 - this.errorCount;
					this.passwordErrorMessage = `${message}，剩余 ${remaining} 次机会`;
				}
				
				// 显示错误消息
				this.$message.error(this.passwordErrorMessage);
			},
		},
	};
</script>

<style scoped lang="scss">
	@import './index.scss';
</style>