<template>
	<div class="home">
		<!-- 未审核请假申请红色提示弹窗 -->
		<el-dialog 
			title="请假申请审核提醒" 
			:visible.sync="showLeaveWarningDialog" 
			width="500px"
			:show-close="true"
			:close-on-click-modal="false"
			:close-on-press-escape="false">
			<div style="text-align: center; padding: 20px 0;">
				<i class="el-icon-warning" style="font-size: 48px; color: #f56c6c; margin-bottom: 20px;"></i>
				<div style="font-size: 18px; color: #333; margin-bottom: 10px;">
					您有未审核的请假申请需要处理
				</div>
				<div style="font-size: 14px; color: #666;">
					当前有 <span style="color: #f56c6c; font-weight: bold;">{{ pendingLeaveCount }}</span> 个请假申请待审核
				</div>
			</div>
			<div slot="footer" class="dialog-footer">
				<el-button size="small" @click="handleWarningClose">我知道了</el-button>
				<el-button size="small" type="primary" @click="goToLeaveReview">去处理</el-button>
			</div>
		</el-dialog>
		
		<!-- 用户信息 -->
		<el-row :gutter="15">
			<el-col :md="24" :lg="16" :xl="16" class="mb15">
				<el-card shadow="hover">
					<div slot="header">
						<span>{{ $t('message.card.title1') }}</span>
					</div>
					<div class="user-item">
						<div class="user-item-left">
							<img src="../../../static/images/guanli.jpg" />
						</div>
						<div class="user-item-right overflow">
							<el-row>
								<el-col :span="24" class="right-title mb15 one-text-overflow"
									>{{ currentTime }}，{{ realName || username }}，{{ dailyMessage }}
								</el-col>
								<el-col :span="24">
									<el-col :xs="12" :sm="12" :md="8" class="right-l-v">
										<div class="right-label">昵称：</div>
										<div class="right-value">
											{{ realName || username }}
										</div>
									</el-col>
									<el-col :xs="12" :sm="12" :md="16" class="right-l-v">
										<div class="right-label">身份：</div>
										<div class="right-value">{{ userLevel || cx }}</div>
									</el-col>
								</el-col>
								<el-col :span="24" class="mt5">
									<el-col :xs="12" :sm="12" :md="32" class="right-l-v">
										<div class="right-label one-text-overflow">时间：</div>
										<div class="right-value one-text-overflow">{{ userInfo.time }}</div>
									</el-col>
								</el-col>
							</el-row>
						</div>
					</div>
				</el-card>
			</el-col>
		</el-row>

	</div>
</template>
<script>
import * as echarts from 'echarts';
import Scroll from 'vue-seamless-scroll';
import { CountUp } from 'countup.js';
import { Session } from '@/utils/storage';
import { formatAxis, formatDate } from '@/utils/formatTime';
import { recommendList, chartsRightList, newsInfoList, dailyMessage } from './mock';
import { qingjiashenqingList } from '@/api/qingjiashenqing/qingjiashenqingApi';
import { guanliyuanDetail } from '@/api/guanliyuan/guanliyuanApi';
import { jiaoshixinxiDetail } from '@/api/jiaoshixinxi/jiaoshixinxiApi';
import { xueshengxinxiDetail } from '@/api/xueshengxinxi/xueshengxinxiApi';
export default {
	name: 'home',
	components: { Scroll },
	data() {
		return {
			recommendList,
			userInfo: {},
				username:'',
			realName:'', // 数据库中的真实姓名
			userLevel:'', // 数据库中的level信息
			cx:'',
			dailyMessage: {},
			showLeaveWarningDialog: false,
			pendingLeaveCount: 0,
			charts: {
				theme: '',
				bgColor: '',
			},
			global: {
				homeChartOne: null,
				homeChartTwo: null,
				homeCharThree: null,
				dispose: [null, '', undefined],
			},
		};
	},
	created() {
		this.initUserInfo();
		this.initDailyMessage();
		this.checkPendingLeaves();
	},
	computed: {
		currentTime() {
			return formatAxis(new Date());
		},
		optionSingleHeight() {
			return {
				singleHeight: 28,
				limitMoveNum: 8,
				waitTime: 2000,
			};
		},
		getUserInfos() {
			return this.$store.state.userInfos.userInfos;
		},
	},
	methods: {
		// 随机语录
		initDailyMessage() {
			this.dailyMessage = dailyMessage[Math.floor(Math.random() * dailyMessage.length)];
		},
		
		// 检查待审核的请假申请
		async checkPendingLeaves() {
			try {
				// 获取所有请假申请数据
				const response = await qingjiashenqingList({
					page: 1,
					limit: 1000, // 获取足够的记录数
					issh: '待审核' // 只查询待审核的
				});
				
				if (response.success && response.data) {
					// 统计待审核的请假申请数量
					const pendingLeaves = response.data.list || [];
					this.pendingLeaveCount = pendingLeaves.length;
					
					// 如果有待审核的申请，显示弹窗
					if (this.pendingLeaveCount > 0) {
						this.showLeaveWarningDialog = true;
					}
				}
			} catch (error) {
				console.error('获取待审核请假申请失败:', error);
				// 即使获取失败也不影响首页显示
			}
		},
		
		// 关闭警告弹窗
		handleWarningClose() {
			this.showLeaveWarningDialog = false;
		},
		
		// 跳转到请假审核页面
		goToLeaveReview() {
			this.showLeaveWarningDialog = false;
			// 跳转到请假申请查询页面
			this.$router.push('/qingjiashenqing');
		},
		// 初始化登录信息
		async initUserInfo() {
			if (!Session.get('userInfo')) return false;
			this.userInfo = Session.get('userInfo');
			this.username=localStorage.getItem("username");
			this.cx=localStorage.getItem("cx");
			this.userInfo.time = formatDate(new Date(this.userInfo.time), 'YYYY-mm-dd HH:MM:SS');
			
			// 根据用户角色获取数据库中的真实姓名信息
			await this.fetchUserRealInfo();
		},
		
		// 根据用户角色获取数据库中的真实信息
		async fetchUserRealInfo() {
			try {
				const userId = this.userInfo.id;
				const userRole = this.userInfo.roles[0];
				
				let userDetail;
				switch(userRole) {
					case 'guanliyuan':
						// 管理员
						userDetail = await guanliyuanDetail(userId);
						if (userDetail.code === '0' && userDetail.data) {
							// 优先使用姓名，如果没有则使用用户名
							this.realName = userDetail.data.xingming || userDetail.data.yonghuming || this.username;
							// 获取level信息
							this.userLevel = userDetail.data.level || '管理员';
						}
						break;
					case 'jiaoshi':
						// 教师
						userDetail = await jiaoshixinxiDetail(userId);
						if (userDetail.code === '0' && userDetail.data) {
							this.realName = userDetail.data.xingming || this.username;
							// 获取level信息（职称）
							this.userLevel = userDetail.data.zhicheng || '教师';
						}
						break;
					case 'xuesheng':
						// 学生
						userDetail = await xueshengxinxiDetail(userId);
						if (userDetail.code === '0' && userDetail.data) {
							this.realName = userDetail.data.xingming || this.username;
							// 获取level信息（级别）
							this.userLevel = userDetail.data.level || '学生';
						}
						break;
					default:
						// 未知角色，使用用户名
						this.realName = this.username;
						this.userLevel = this.cx;
						break;
				}
				
				// 如果获取失败，使用用户名作为备用
				if (!this.realName) {
					this.realName = this.username;
				}
				// 如果level获取失败，使用默认身份
				if (!this.userLevel) {
					this.userLevel = this.cx;
				}
				
			} catch (error) {
				console.error('获取用户真实信息失败:', error);
				// 发生错误时使用默认信息作为备用
				this.realName = this.username;
				this.userLevel = this.cx;
			}
		},
		// 消息通知当前项点击
		onNewsInfoListClick(v) {
			window.open(v.link);
		},
	},
	watch: {
		// 监听 vuex 数据变化
		'$store.state.themeConfig.themeConfig.isIsDark': {
			handler(isIsDark) {
				this.$nextTick(() => {
					this.charts.theme = isIsDark ? 'dark' : '';
					this.charts.bgColor = isIsDark ? 'transparent' : '';
					setTimeout(() => {
						//this.initHomeStock();
					}, 500);
					setTimeout(() => {
						//this.initHomeLaboratory();
					}, 700);
					setTimeout(() => {
						//this.initHomeOvertime();
					}, 1000);
				});
			},
			deep: true,
			immediate: true,
		},
	},
};
</script>

<style scoped lang="scss">
@import './index.scss';
</style>