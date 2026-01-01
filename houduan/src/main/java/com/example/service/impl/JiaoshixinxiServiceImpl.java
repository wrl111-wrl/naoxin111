package com.example.service.impl;

import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.ResultCode;
import com.example.dao.*;
import com.example.entity.Jiaoshixinxi;
import com.example.exception.CustomException;
import com.example.service.JiaoshixinxiService;
import com.example.vo.JiaoshixinxiVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;

@Service("jiaoshixinxiService")
public class JiaoshixinxiServiceImpl extends ServiceImpl<JiaoshixinxiDao, Jiaoshixinxi> implements JiaoshixinxiService {

    @Resource
    private JiaoshixinxiDao jiaoshixinxiDao;

    public Jiaoshixinxi add(Jiaoshixinxi jiaoshixinxi) {
		if(jiaoshixinxi.getMima()==null) {jiaoshixinxi.setMima("e10adc3949ba59abbe56e057f20f883e");}else {jiaoshixinxi.setMima(SecureUtil.md5(jiaoshixinxi.getMima())); }
	    LambdaQueryWrapper<Jiaoshixinxi> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Jiaoshixinxi::getGonghao,jiaoshixinxi.getGonghao());
        Jiaoshixinxi findJiaoshixinxi = jiaoshixinxiDao.selectOne(wrapper);
        if (findJiaoshixinxi != null) {
            throw new CustomException("1001", "" + jiaoshixinxi.getGonghao() + "\"已存在");
        }
        jiaoshixinxi.setAddtime(new Date());
        jiaoshixinxiDao.insert(jiaoshixinxi);
        return jiaoshixinxi;
    }
	
	@Override
    public List<Map<String,Object>> jiaoshixinxi_tj_xingbie() {
    List<Map<String,Object>> returnMap = jiaoshixinxiDao.jiaoshixinxi_tj_xingbie();
    return returnMap;
    }
    
	
    public void delete(Long id) {
        jiaoshixinxiDao.deleteById(id);
    }
	

    public void update(Jiaoshixinxi jiaoshixinxi) {
         LambdaQueryWrapper<Jiaoshixinxi> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Jiaoshixinxi::getGonghao,jiaoshixinxi.getGonghao());
        Jiaoshixinxi findJiaoshixinxi = jiaoshixinxiDao.selectOne(wrapper);
		if (findJiaoshixinxi != null && jiaoshixinxi.getId() != findJiaoshixinxi.getId()) {
            throw new CustomException("1001", "" + jiaoshixinxi.getGonghao() + "\"已存在");
        }
        jiaoshixinxiDao.updateById(jiaoshixinxi);
    }
	
	@Override
    public List<Map<String, Object>> daochuexcel() {
        return jiaoshixinxiDao.daochuexcel();
    }

    @Override
    public Jiaoshixinxi findById(Integer id) {
        return jiaoshixinxiDao.selectById(id);
    }

    public JiaoshixinxiVo findPage(JiaoshixinxiVo jiaoshixinxiVo) {
        LambdaQueryWrapper<Jiaoshixinxi> wrapper = Wrappers.lambdaQuery();
		wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getGonghao()), Jiaoshixinxi::getGonghao,jiaoshixinxiVo.getGonghao());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getMima()), Jiaoshixinxi::getMima,jiaoshixinxiVo.getMima());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getXingming()), Jiaoshixinxi::getXingming,jiaoshixinxiVo.getXingming());
        wrapper.eq(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getXingbie()), Jiaoshixinxi::getXingbie,jiaoshixinxiVo.getXingbie());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getShenfenzheng()), Jiaoshixinxi::getShenfenzheng,jiaoshixinxiVo.getShenfenzheng());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getDianhua()), Jiaoshixinxi::getDianhua,jiaoshixinxiVo.getDianhua());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getZhicheng()), Jiaoshixinxi::getZhicheng,jiaoshixinxiVo.getZhicheng());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getZhujiaokecheng()), Jiaoshixinxi::getZhujiaokecheng,jiaoshixinxiVo.getZhujiaokecheng());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getBanji()), Jiaoshixinxi::getBanji,jiaoshixinxiVo.getBanji());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getJiguan()), Jiaoshixinxi::getJiguan,jiaoshixinxiVo.getJiguan());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getZhaopian()), Jiaoshixinxi::getZhaopian,jiaoshixinxiVo.getZhaopian());
        wrapper.like(ObjectUtils.isNotEmpty(jiaoshixinxiVo.getBeizhu()), Jiaoshixinxi::getBeizhu,jiaoshixinxiVo.getBeizhu());
        
        Page<Jiaoshixinxi> page = new Page<>(jiaoshixinxiVo.getCurrent(),jiaoshixinxiVo.getCurrentNum());
        jiaoshixinxiDao.selectPage(page,wrapper);
        List<Jiaoshixinxi> jiaoshixinxis = page.getRecords();
        jiaoshixinxiVo.setList(jiaoshixinxis);
        jiaoshixinxiVo.setPages(page.getPages());
        jiaoshixinxiVo.setTotal(page.getTotal());
        jiaoshixinxiVo.setCurrent(page.getCurrent());
        jiaoshixinxiVo.setCurrentNum(page.getSize());
        return jiaoshixinxiVo;
    }

    @Override
    public void deleteList(List<Jiaoshixinxi> list) {
        List<Integer> ids =  list.stream().map(Jiaoshixinxi::getId).collect(Collectors.toList());
        jiaoshixinxiDao.deleteBatchIds(ids);
    }
	
	@Override
    public Jiaoshixinxi login(Jiaoshixinxi jiaoshixinxi) {
        LambdaQueryWrapper<Jiaoshixinxi> wrapper = new LambdaQueryWrapper();
        wrapper.eq(ObjectUtils.isNotEmpty(jiaoshixinxi.getGonghao()), Jiaoshixinxi::getGonghao,jiaoshixinxi.getGonghao());
        Jiaoshixinxi jiaoshixinxiInfo = jiaoshixinxiDao.selectOne(wrapper);
        if (jiaoshixinxiInfo == null) {
            throw new CustomException(ResultCode.USER_ACCOUNT_ERROR);
        }
        if (!SecureUtil.md5(jiaoshixinxi.getMima()).equalsIgnoreCase(jiaoshixinxiInfo.getMima())) {
            throw new CustomException(ResultCode.USER_ACCOUNT_ERROR);
        }
        return jiaoshixinxiInfo;
    }
	
	
	
	//youxxianxci
}
