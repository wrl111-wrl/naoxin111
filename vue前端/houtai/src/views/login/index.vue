<template>
	<div class="login-page-container">
		<!-- Logo：左上角独立定位 -->
		<img src="./logo.jpg" alt="系统Logo" class="login-logo">
		
		<!-- 登录表单容器 -->
		<div class="w3layouts-main">
			<!-- 标题：居中 + 间距 -->
			<h2 class="title-center">{{ getThemeConfig.globalTitle || '学生请假管理系统' }}</h2>
			
			<el-form class="el-form login-form" :model="ruleForm" :rules="rules" ref="ruleForm">
				<el-form-item style="margin-left: 0px" prop="username">
					<el-input
							type="text"
							:placeholder="$t('message.login.placeholder1') || '请输入用户名'"
							prefix-icon="el-icon-user"
							v-model="ruleForm.username"
							clearable
							autocomplete="off"
					></el-input>
				</el-form-item>
				<el-form-item style="margin-left: 0px" prop="password">
					<el-input
							type="password"
							:placeholder="$t('message.login.placeholder2') || '请输入密码'"
							prefix-icon="el-icon-lock"
							v-model="ruleForm.password"
							autocomplete="off"
							:show-password="true"
					></el-input>
				</el-form-item>
				<el-form-item prop="role">
					<el-radio v-model='ruleForm.role' label='管理员'>管理员 &nbsp;</el-radio>
	                <el-radio v-model='ruleForm.role' label='教师'>教师 &nbsp;</el-radio>
	                <el-radio v-model='ruleForm.role' label='学生'>学生 &nbsp;</el-radio>
				</el-form-item>
				<el-form-item style="margin-left: 0px" prop="code">
					<div class="el-row" span="24">
						<div class="el-col el-col-16">
							<el-input
									type="text"
									maxlength="4"
									:placeholder="$t('message.login.placeholder3') || '请输入验证码'"
									prefix-icon="el-icon-position"
									v-model="ruleForm.code"
									clearable
									autocomplete="off"
							></el-input>
						</div>
						<div class="el-col el-col-8">
							<div class="login-code">
								<span class="login-code-img" @click="changeCode">{{code}}</span>
							</div>
						</div>
					</div>
				</el-form-item>
				<el-form-item style="margin: 40px 0px 0">
					<el-button type="primary" class="login-submit" @click="submitForm('ruleForm')" :loading="submit.loading"><span>{{ $t('message.login.btnText') || '登录' }}</span></el-button>
					<el-button type="primary" class="login-submit" @click="zhuce" ><span>注册</span></el-button>
				</el-form-item>
			</el-form>
		</div>

		<!-- 版权信息：下端居中 -->
		<div class="copyright-text">
			Copyright @2025 闹心NX.com 版权所有
		</div>
	</div>
</template>

<script>
import { Session } from '@/utils/storage';
import { formatDate, formatAxis } from '@/utils/formatTime';
import { PrevLoading } from '@/utils/loading.js';
import { quotationsList } from './mock';
import { login } from '../../api/login/index.js'

export default {
	name: 'login',
	data() {
		return {
			quotationsList,
			quotations: {},
			isView: false,
			submit: {
				loading: false,
			},
			ruleForm: {
				username: '',
				password: '',
				code: '',
				role: '管理员'
			},
			time: {
				txt: '',
				fun: null,
			},
			rules: {
				username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
				password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
				code: [{ required: true,trigger: 'blur',validator: this.codeValidator }],
				role:[{required:true,message:'请选择角色'}]
			},
			code:'',
		};
	},
	computed: {
		currentTime() {
			return formatAxis(new Date());
		},
		getThemeConfig() {
			return this.$store.state.themeConfig?.themeConfig || {};
		},
	},
	created() {
		this.initTime();
		this.initCode();
	},
	mounted() {
		this.initRandomQuotations();
	},
	methods: {
		codeValidator(rule,value,callback){
			let res
			if(!value) {
				res = rule.required ? new Error('请输入验证码信息') : undefined
			} else {
				const val = value.trim();
				if(val != this.code){
					res = new Error("验证码信息不正确")
				}
			}
			callback(res)
		},
		zhuce(){
			this.$router.push({name:'register'})
		},
		initRandomQuotations() {
			this.quotations = this.quotationsList[Math.floor(Math.random() * this.quotationsList.length)];
		},
		initTime() {
			this.time.txt = formatDate(new Date(), 'YYYY-mm-dd HH:MM:SS WWW QQQQ');
			this.time.fun = setInterval(() => {
				this.time.txt = formatDate(new Date(), 'YYYY-mm-dd HH:MM:SS WWW QQQQ');
			}, 1000);
		},
		initCode(){
			let code = Math.floor(Math.random()*(9999-1000))+1000;
			this.code = code;
		},
		changeCode(){
			this.initCode();
		},
		submitForm(formName) {
			this.$refs[formName].validate(valid => {
				if (valid) {
					this.submit.loading = true;
					login(this.ruleForm).then(res=> {
							let defaultRoles = [];
							let defaultAuthBtnList = [];
							let guanliyuanRoles = ['guanliyuan'];
							let jiaoshiRoles = ['jiaoshi'];
							let xueshengRoles = ['xuesheng'];
							let adminAuthBtnList = ['btn.add', 'btn.del', 'btn.edit', 'btn.link'];
							
							if (this.ruleForm.role === '管理员') {
								defaultRoles = guanliyuanRoles;
								defaultAuthBtnList = adminAuthBtnList;
							}
							if (this.ruleForm.role === '教师') {
								defaultRoles = jiaoshiRoles;
								defaultAuthBtnList = adminAuthBtnList;
							}
							if (this.ruleForm.role === '学生') {
								defaultRoles = xueshengRoles;
								defaultAuthBtnList = adminAuthBtnList;
							}

							let user = res.data.user;
							localStorage.setItem("username",this.ruleForm.username);
							localStorage.setItem("cx", this.ruleForm.role);
							
							user = {
								...user,
								time: new Date().getTime(),
								roles: defaultRoles,
								authBtnList: defaultAuthBtnList
							}
							
							Session.set('token', res.data.token);
							Session.set('userInfo',user);
							this.$store.dispatch('userInfos/setUserInfos',user);
							
							PrevLoading.start();
									this.submit.loading = false;
									this.$router.push('/home');
									// 添加一个延时跳转的备份方案，确保能跳转
									setTimeout(() => {
										if (this.$route.path !== '/home') {
											this.$router.replace('/home');
										}
									}, 500);
							
							setTimeout(() => {
								this.$message.success(`${this.currentTime}，${this.$t('message.login.signInText') || '登录成功'}`);
							}, 300);
					}).catch(msg =>{
						this.submit.loading = false;
						this.$message({
							type: 'error',
							message: msg || '登录失败'
						})
					})
				}
			})
		},
	},
	destroyed() {
		clearInterval(this.time.fun);
	},
};
</script>

<style scoped lang="scss">
/* 外层页面容器 */
.login-page-container {
	width: 100vw;
	height: 100vh;
	background: url(./123123123.jpg) no-repeat 0px 0px;
	background-size: cover;
	position: relative;
	padding-top: 60px;
	box-sizing: border-box;
}

/* Logo样式 */
.login-logo {
	position: absolute;
	top: 20px;
	left: 20px;
	width: 60px;
	height: 60px;
	border-radius: 8px;
	object-fit: cover;
	z-index: 999;
	box-shadow: 0 0 5px rgba(0,0,0,0.3);
}

/* 表单容器 */
.w3layouts-main {
	width: 30%;
	margin: 0 auto;
	background:rgba(171, 119, 157, 0.27);
	padding: 42px 35px;
	position: relative;
	z-index: 1;
	border-radius: 8px;
}

/* 标题样式：居中 + 间距 */
.title-center {
	text-align: center;
	margin-bottom: 30px;
	font-size: 24px;
	color: #fff;
	font-weight: 600;
	text-shadow: 0 0 3px rgba(0,0,0,0.5);
}

/* 表单样式 */
.login-form {
	width: 100%;
}

/* 验证码区域 */
.login-code {
	display: flex;
	align-items: center;
	justify-content: space-around;
	margin: 0 0 0 10px;
	user-select: none;
	
	.login-code-img {
		margin-top: 2px;
		width: 100px;
		height: 38px;
		border: 1px solid #ddd;
		color: #333;
		font-size: 14px;
		font-weight: 700;
		letter-spacing: 5px;
		line-height: 38px;
		text-indent: 5px;
		text-align: center;
		cursor: pointer;
		transition: all ease 0.2s;
		border-radius: 4px;
		background: rgba(255,255,255,0.8);
		
		&:hover {
			border-color: #999;
			background: rgba(255,255,255,1);
		}
	}
}

/* 登录按钮 */
.login-submit {
	width: 45%;
	margin: 0 2%;
}

/* 版权信息 */
.copyright-text {
	position: absolute;
	bottom: 20px;
	left: 50%;
	transform: translateX(-50%);
	color: #fff;
	font-size: 14px;
	text-shadow: 0 0 3px rgba(0,0,0,0.8);
	z-index: 999;
	letter-spacing: 1px;
}

/* 全局样式重置 */
html, body {
	margin: 0;
	padding: 0;
	overflow-x: hidden;
	font-family: 'Microsoft Yahei', sans-serif;
}

.el-form-item {
	margin-bottom: 20px;
}

.el-radio {
	color: #fff;
}
</style>