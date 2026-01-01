<template>
	<div class="home">
		<el-row :gutter="15">
			<el-col :md="24" :lg="12" :xl="12" class="home-lg">
				<el-card shadow="hover">
					<div slot="header">
						<span>报名统计（饼图按专业）</span>
					</div>
					<div class="charts">
						<div class="charts-left mr7">
							<div id="ref1" class="h100"></div>
						</div>
					</div>
				</el-card>
			</el-col>
			<el-col :md="24" :lg="12" :xl="12" class="home-lg">
				<el-card shadow="hover">
					<div slot="header">
						<span>报名统计（柱形图按专业）</span>
					</div>
					<div class="charts">
						<div class="charts-left mr7">
							<div id="ref2" class="h100"></div>
						</div>
					</div>
				</el-card>
			</el-col>
		</el-row>
	</div>
</template>

<script>
	import * as echarts from "echarts";
	import Pagination from "@/layout/pagination/Pagination";
	import {Session} from "@/utils/storage";
	import {xueshengxinxi_tj_yuanxi} from "@/api/xueshengxinxi/xueshengxinxiApi";
export default {
	name: 'user',
	data() {
		return {
			loading: false, //是显示加载
			user:[],
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
		this.initChart();
	},
	methods: {
		initChart() {
			xueshengxinxi_tj_yuanxi().then(res=>{
				let data = res.data
				let value = []
				data.forEach(item=>{
					value.push({name:item.aa,value:item.bb})
				})
				let xData = []
				let yData = []
				data.forEach(item=>{
					xData.push(item.aa)
					yData.push(item.bb)
				})
				let chart = echarts.init(document.getElementById("ref1"));
				const option = {
					title: {
						text: '院系统计',
						left: 'center'
					},
					tooltip: {
						trigger: 'item'
					},
					legend: {
						orient: 'vertical',
						left: 'left'
					},
					series: [
						{
							name: '院系',
							type: 'pie',
							radius: '50%',
							data: value,
							emphasis: {
								itemStyle: {
									shadowBlur: 10,
									shadowOffsetX: 0,
									shadowColor: 'rgba(0, 0, 0, 0.5)'
								}
							}
						}
					]
				};
				chart.setOption(option);
				window.addEventListener('resize', () => {
					chart.resize();
				});
				let chart2 = echarts.init(document.getElementById("ref2"));
				const option2 = {
					title: {
						text: '院系统计',
						left: 'center'
					},
					grid: {
						left: '3%',
						right: '4%',
						bottom: '3%',
						containLabel: true
					},
					tooltip: {
						trigger: 'axis',
						axisPointer: {
							type: 'shadow'
						}
					},
					xAxis: {
						type: 'category',
						data: xData
					},
					yAxis: {
						type: 'value'
					},
					series: [
						{
							type: 'bar',
							data: yData,
						}
					]
				};
				chart2.setOption(option2);
				window.addEventListener('resize', () => {
					chart2.resize();
				});
			})
		},

	},
};
</script>

<style scoped lang="scss">
	@import './index.scss';
</style>
