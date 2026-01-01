package com.example.service.impl;

import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.ResultCode;
import com.example.dao.*;
import com.example.entity.Xueshengxinxi;
import com.example.exception.CustomException;
import com.example.service.XueshengxinxiService;
import com.example.vo.XueshengxinxiVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;

@Service("xueshengxinxiService")
public class XueshengxinxiServiceImpl extends ServiceImpl<XueshengxinxiDao, Xueshengxinxi> implements XueshengxinxiService {

    @Resource
    private XueshengxinxiDao xueshengxinxiDao;

    public Xueshengxinxi add(Xueshengxinxi xueshengxinxi) {
		if(xueshengxinxi.getMima()==null) {xueshengxinxi.setMima(SecureUtil.md5("001"));}else {xueshengxinxi.setMima(SecureUtil.md5(xueshengxinxi.getMima())); }
	    LambdaQueryWrapper<Xueshengxinxi> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Xueshengxinxi::getXuehao,xueshengxinxi.getXuehao());
        Xueshengxinxi findXueshengxinxi = xueshengxinxiDao.selectOne(wrapper);
        if (findXueshengxinxi != null) {
            throw new CustomException("1001", "" + xueshengxinxi.getXuehao() + "\"已存在");
        }
        xueshengxinxi.setAddtime(new Date());
        xueshengxinxiDao.insert(xueshengxinxi);
        return xueshengxinxi;
    }
	
	@Override    public List<Map<String,Object>> xueshengxinxi_tj_xingbie() {    List<Map<String,Object>> returnMap = xueshengxinxiDao.xueshengxinxi_tj_xingbie();    return returnMap;    }    @Override    public List<Map<String,Object>> xueshengxinxi_tj_banji() {    List<Map<String,Object>> returnMap = xueshengxinxiDao.xueshengxinxi_tj_banji();    return returnMap;    }    
	
    public void delete(Long id) {
        xueshengxinxiDao.deleteById(id);
    }
	

    public void update(Xueshengxinxi xueshengxinxi) {
         LambdaQueryWrapper<Xueshengxinxi> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(Xueshengxinxi::getXuehao,xueshengxinxi.getXuehao());
        Xueshengxinxi findXueshengxinxi = xueshengxinxiDao.selectOne(wrapper);
		if (findXueshengxinxi != null && xueshengxinxi.getId() != findXueshengxinxi.getId()) {
            throw new CustomException("1001", "" + xueshengxinxi.getXuehao() + "\"已存在");
        }
        xueshengxinxiDao.updateById(xueshengxinxi);
    }
	
	@Override
    public List<Map<String, Object>> daochuexcel() {
        return xueshengxinxiDao.daochuexcel();
    }

    @Override
    public Xueshengxinxi findById(Integer id) {
        return xueshengxinxiDao.selectById(id);
    }

    public XueshengxinxiVo findPage(XueshengxinxiVo xueshengxinxiVo) {
        LambdaQueryWrapper<Xueshengxinxi> wrapper = Wrappers.lambdaQuery();
		wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getXuehao()), Xueshengxinxi::getXuehao,xueshengxinxiVo.getXuehao());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getMima()), Xueshengxinxi::getMima,xueshengxinxiVo.getMima());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getXueshengxingming()), Xueshengxinxi::getXueshengxingming,xueshengxinxiVo.getXueshengxingming());        wrapper.eq(ObjectUtils.isNotEmpty(xueshengxinxiVo.getXingbie()), Xueshengxinxi::getXingbie,xueshengxinxiVo.getXingbie());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getShenfenzheng()), Xueshengxinxi::getShenfenzheng,xueshengxinxiVo.getShenfenzheng());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getDianhua()), Xueshengxinxi::getDianhua,xueshengxinxiVo.getDianhua());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getBanji()), Xueshengxinxi::getBanji,xueshengxinxiVo.getBanji());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getJiguan()), Xueshengxinxi::getJiguan,xueshengxinxiVo.getJiguan());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getZhaopian()), Xueshengxinxi::getZhaopian,xueshengxinxiVo.getZhaopian());        wrapper.like(ObjectUtils.isNotEmpty(xueshengxinxiVo.getBeizhu()), Xueshengxinxi::getBeizhu,xueshengxinxiVo.getBeizhu());        
        Page<Xueshengxinxi> page = new Page<>(xueshengxinxiVo.getCurrent(),xueshengxinxiVo.getCurrentNum());
        xueshengxinxiDao.selectPage(page,wrapper);
        List<Xueshengxinxi> xueshengxinxis = page.getRecords();
        xueshengxinxiVo.setList(xueshengxinxis);
        xueshengxinxiVo.setPages(page.getPages());
        xueshengxinxiVo.setTotal(page.getTotal());
        xueshengxinxiVo.setCurrent(page.getCurrent());
        xueshengxinxiVo.setCurrentNum(page.getSize());
        return xueshengxinxiVo;
    }

    @Override
    public void deleteList(List<Xueshengxinxi> list) {
        List<Integer> ids =  list.stream().map(Xueshengxinxi::getId).collect(Collectors.toList());
        xueshengxinxiDao.deleteBatchIds(ids);
    }
	
	@Override
    public Xueshengxinxi login(Xueshengxinxi xueshengxinxi) {
        LambdaQueryWrapper<Xueshengxinxi> wrapper = new LambdaQueryWrapper();
        wrapper.eq(ObjectUtils.isNotEmpty(xueshengxinxi.getXuehao()), Xueshengxinxi::getXuehao,xueshengxinxi.getXuehao());
        Xueshengxinxi xueshengxinxiInfo = xueshengxinxiDao.selectOne(wrapper);
        if (xueshengxinxiInfo == null) {
            throw new CustomException(ResultCode.USER_ACCOUNT_ERROR);
        }
        if (!SecureUtil.md5(xueshengxinxi.getMima()).equalsIgnoreCase(xueshengxinxiInfo.getMima())) {
            throw new CustomException(ResultCode.USER_ACCOUNT_ERROR);
        }
        return xueshengxinxiInfo;
    }
	
	
	
	//youxxianxci
}
