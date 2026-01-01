<template>
	<div class="personal">
  <el-form label-width="80px" ref="editForm" :model="editForm" :rules="rules">
    <el-form-item label="学号" prop="xuehao">
      <el-input size="small" v-model="editForm.xuehao" auto-complete="off" placeholder="请输入学号" style='width:25%'></el-input>
    </el-form-item>
    
    <el-form-item label="学生姓名" prop="xueshengxingming">
      <el-input size="small" v-model="editForm.xueshengxingming" auto-complete="off" placeholder="请输入学生姓名" style='width:25%'></el-input>
    </el-form-item>
    
    <!-- 性别字段改为只读显示 -->
    <el-form-item label="性别">
      <el-input 
        size="small" 
        :value="editForm.xingbie ? '男' : '女'" 
        disabled 
        style='width:25%'
      ></el-input>
    </el-form-item>
    
    <el-form-item label="身份证" prop="shenfenzheng">
      <el-input size="small" v-model="editForm.shenfenzheng" auto-complete="off" placeholder="请输入身份证" style='width:50%'></el-input>
    </el-form-item>
    
    <el-form-item label="电话" prop="dianhua">
      <el-input size="small" v-model="editForm.dianhua" auto-complete="off" placeholder="请输入电话" style='width:25%'></el-input>
    </el-form-item>
    
    <el-form-item label='班级' prop="banji">
      <el-select size="small" v-model="editForm.banji" placeholder="请选择">
        <el-option selected label="请选择" value=""></el-option>
        <el-option label="A01" value="A01"></el-option>
        <el-option label="A02" value="A02"></el-option>
        <el-option label="A03" value="A03"></el-option>
	  </el-select>
    </el-form-item>
    
    <el-form-item label="籍贯" prop="jiguan">
      <el-select size="small" v-model="editForm.jiguan" placeholder="请选择籍贯" style='width:25%'>
        <el-option selected label="请选择" value=""></el-option>
        <el-option v-for="province in provinces" :key="province" :label="province" :value="province"></el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item label='照片' prop='zhaopian'>
      <el-upload class='avatar-uploader' action='http://localhost:9999/files/upload' :headers='headers' :show-file-list='false' :on-success='handleZhaopianSuccess' :before-upload='beforeZhaopianUpload'>
        <img v-if='editForm.zhaopian' :src='editForm.zhaopian' class='avatar'>
        <i v-else class='el-icon-plus avatar-uploader-icon'></i>
      </el-upload>
    </el-form-item>
    
    <el-form-item label="备注" prop="beizhu">
      <el-input type="textarea" size="small" v-model="editForm.beizhu" auto-complete="off" placeholder="请输入备注" style='width:50%'></el-input>
    </el-form-item>
  </el-form>
  
  <div slot="footer" class="dialog-footer">
    <el-button size="small" type="primary" :loading="loading" class="title" @click="submitForm('editForm')">更新</el-button>
  </div>
</div>
</template>

<script>
	import {xueshengxinxiEdit, xueshengxinxiSave,xueshengxinxiDetail} from "@/api/xueshengxinxi/xueshengxinxiApi";
	import { provinces } from '@/utils/provinces';
	import {Session} from "@/utils/storage";

export default {
	name: 'personal',
	data() {
		return {
			rules: {
				xuehao: [
					{ required: true, message: '请输入学号', trigger: 'blur' },
					{ pattern: /^\d{3}$/, message: '学号仅支持3位数字', trigger: 'blur' }
				],
				mima: [{ required: true, message: '请输入密码', trigger: 'blur' },
				],
				xueshengxingming: [
					{ required: true, message: '请输入学生姓名', trigger: 'blur' },
					{ pattern: /^[\u4e00-\u9fa5]{1,10}$/, message: '姓名仅支持1-10个汉字', trigger: 'blur' }
				],
				shenfenzheng: [{ required: true, message: '请输入身份证', trigger: 'blur' },
				{ pattern:/^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/,required: true,message: '请输入正确身份证号',trigger: 'blur'}
				],
				dianhua: [{ required: true, message: '请输入电话', trigger: 'blur' },
				{ pattern: /^[1][3,4,5,7,8][0-9]{9}$/,required: true,message: '请输入正确的手机号',trigger: 'blur'}
				],
				
			},
			editForm: {
				avater:''
			},
			provinces: provinces,
		};
	},
	created() {
		this.getDetail()
	},
	computed: {
		headers(){
			return {"token":Session.get("token")}
		},
	},
	methods:{
		getDetail(){
			if (!Session.get('userInfo')) return false;
			this.userInfo = Session.get('userInfo');
			console.log(this.userInfo);
			xueshengxinxiDetail(this.userInfo.id).then(res=>{
				if (res.code == '0') {
					// 确保editForm是一个对象，避免res.data为null的情况
					this.editForm = res.data || {};
					// 处理空值，将null、空字符串或"???"转换为中文提示
					Object.keys(this.editForm).forEach(key => {
						if (this.editForm[key] === null || this.editForm[key] === '' || this.editForm[key] === '???' || this.editForm[key] === '??') {
							this.editForm[key] = '未设置';
						}
					});
				}
			}).catch(err => {
				if(err){
					this.$message.error(err)
				}else {
					this.$message.error('操作失败，请稍后再试！')
				}
			})
		},
		
		// 编辑、增加页面保存方法
		submitForm(editData) {
			this.$refs[editData].validate(valid => {
				if (valid) {
					if(this.editForm.id){
						xueshengxinxiEdit(this.editForm).then(res => {
							if (res.code == '0') {
								this.getDetail()
								this.$message({
									type: 'success',
									message: '个人信息修改成功！'
								})
								this.$store.dispatch('userInfos/setUserInfos',this.editForm);
							} else {
								this.$message({
									type: 'info',
									message: res.msg
								})
							}
						}).catch(err => {
							if(err){
								this.$message.error(err)
							}else {
								this.$message.error('操作失败，请稍后再试！')
							}
						})
					}else {
						xueshengxinxiSave(this.editForm).then(res => {
							if (res.code == '0') {
								this.getDetail()
								this.$message({
									type: 'success',
									message: '个人信息添加成功！'
								})
							} else {
								this.$message({
									type: 'info',
									message: res.msg
								})
							}
						}).catch(err => {
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
				
	}
};
</script>

<style scoped lang="scss">
	@import './index.scss';
</style>
