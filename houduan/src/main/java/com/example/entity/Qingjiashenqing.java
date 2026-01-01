package com.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;


@TableName("qingjiashenqing")
@Data
public class Qingjiashenqing {
    @TableId(value = "id",type = IdType.AUTO)
    private Integer id;

    @TableField(value = "qingjiabianhao")
    private String qingjiabianhao;
    @TableField(value = "xuehao")
    private String xuehao;
    @TableField(value = "xueshengxingming")
    private String xueshengxingming;
    @TableField(value = "lianxidianhua")
    private String lianxidianhua;
    @TableField(value = "banji")
    private String banji;
    @TableField(value = "qingjiayuanyin")
    private String qingjiayuanyin;
    @TableField(value = "qishishijian")
    private String qishishijian;
    @TableField(value = "zhongzhishijian")
    private String zhongzhishijian;
    @TableField(value = "beizhu")
    private String beizhu;
    @TableField(value = "issh")
    private String issh;
    @TableField(value = "shhf")
    private String shhf;
    @TableField(value = "fujian")
    private String fujian;
    @TableField(value = "fujianyuanname")
    private String fujianyuanname;
    @TableField(value = "guanlianxuqiu")
    private String guanlianxuqiu;




    @TableField(value = "addtime")
    private Date addtime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getQingjiabianhao() {
        return qingjiabianhao;
    }
    public void setQingjiabianhao(String qingjiabianhao) {
        this.qingjiabianhao = qingjiabianhao;
    }
    public String getXuehao() {
        return xuehao;
    }
    public void setXuehao(String xuehao) {
        this.xuehao = xuehao;
    }
    public String getXueshengxingming() {
        return xueshengxingming;
    }
    public void setXueshengxingming(String xueshengxingming) {
        this.xueshengxingming = xueshengxingming;
    }
    public String getLianxidianhua() {
        return lianxidianhua;
    }
    public void setLianxidianhua(String lianxidianhua) {
        this.lianxidianhua = lianxidianhua;
    }
    public String getBanji() {
        return banji;
    }
    public void setBanji(String banji) {
        this.banji = banji;
    }
    public String getQingjiayuanyin() {
        return qingjiayuanyin;
    }
    public void setQingjiayuanyin(String qingjiayuanyin) {
        this.qingjiayuanyin = qingjiayuanyin;
    }
    public String getQishishijian() {
        return qishishijian;
    }
    public void setQishishijian(String qishishijian) {
        this.qishishijian = qishishijian;
    }
    public String getZhongzhishijian() {
        return zhongzhishijian;
    }
    public void setZhongzhishijian(String zhongzhishijian) {
        this.zhongzhishijian = zhongzhishijian;
    }
    public String getBeizhu() {
        return beizhu;
    }
    public void setBeizhu(String beizhu) {
        this.beizhu = beizhu;
    }
    public String getIssh() {
        return issh;
    }
    public void setIssh(String issh) {
        this.issh = issh;
    }
    public String getShhf() {
        return shhf;
    }
    public void setShhf(String shhf) {
        this.shhf = shhf;
    }
    public String getFujian() {
        return fujian;
    }
    public void setFujian(String fujian) {
        this.fujian = fujian;
    }
    public String getFujianyuanname() {
        return fujianyuanname;
    }
    public void setFujianyuanname(String fujianyuanname) {
        this.fujianyuanname = fujianyuanname;
    }
    public String getGuanlianxuqiu() {
        return guanlianxuqiu;
    }
    public void setGuanlianxuqiu(String guanlianxuqiu) {
        this.guanlianxuqiu = guanlianxuqiu;
    }


    public Date getAddtime() {
        return addtime;
    }

    public void setAddtime(Date addtime) {
        this.addtime = addtime;
    }
}