package com.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;


@TableName("jiaoshixinxi")
@Data
public class Jiaoshixinxi {
    @TableId(value = "id",type = IdType.AUTO)
    private Integer id;
	
	@TableField(value = "gonghao")	private String gonghao;	@TableField(value = "mima")	private String mima;	@TableField(value = "xingming")	private String xingming;	@TableField(value = "xingbie")	private Boolean xingbie;	@TableField(value = "shenfenzheng")	private String shenfenzheng;	@TableField(value = "dianhua")	private String dianhua;	@TableField(value = "zhicheng")	private String zhicheng;	@TableField(value = "zhujiaokecheng")	private String zhujiaokecheng;	@TableField(value = "banji")	private String banji;	@TableField(value = "jiguan")	private String jiguan;	@TableField(value = "zhaopian")	private String zhaopian;	@TableField(value = "beizhu")	private String beizhu;	@TableField(exist = false)	private String newPassword;	
    
	
	
    @TableField(value = "addtime")
    private Date addtime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

	public String getGonghao() {
        return gonghao;
    }
    public void setGonghao(String gonghao) {
		this.gonghao = gonghao;
    }	public String getMima() {
        return mima;
    }
    public void setMima(String mima) {
		this.mima = mima;
    }	public String getXingming() {
        return xingming;
    }
    public void setXingming(String xingming) {
		this.xingming = xingming;
    }	public Boolean getXingbie() {
        return xingbie;
    }
    public void setXingbie(Boolean xingbie) {
		this.xingbie = xingbie;
    }	public String getShenfenzheng() {
        return shenfenzheng;
    }
    public void setShenfenzheng(String shenfenzheng) {
		this.shenfenzheng = shenfenzheng;
    }	public String getDianhua() {
        return dianhua;
    }
    public void setDianhua(String dianhua) {
		this.dianhua = dianhua;
    }	public String getZhicheng() {
        return zhicheng;
    }
    public void setZhicheng(String zhicheng) {
		this.zhicheng = zhicheng;
    }	public String getZhujiaokecheng() {
        return zhujiaokecheng;
    }
    public void setZhujiaokecheng(String zhujiaokecheng) {
		this.zhujiaokecheng = zhujiaokecheng;
    }	public String getBanji() {
        return banji;
    }
    public void setBanji(String banji) {
		this.banji = banji;
    }	public String getJiguan() {
        return jiguan;
    }
    public void setJiguan(String jiguan) {
		this.jiguan = jiguan;
    }	public String getZhaopian() {
        return zhaopian;
    }
    public void setZhaopian(String zhaopian) {
		this.zhaopian = zhaopian;
    }	public String getBeizhu() {
        return beizhu;
    }
    public void setBeizhu(String beizhu) {
		this.beizhu = beizhu;
    }	public String getNewPassword() {
        return newPassword;
    }
    public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
    }	
	

    public Date getAddtime() {
        return addtime;
    }

    public void setAddtme(Date addtime) {
        this.addtime = addtime;
    }
}