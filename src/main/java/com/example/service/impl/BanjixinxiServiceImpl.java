package com.example.service.impl;

import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.ResultCode;
import com.example.dao.*;
import com.example.entity.Banjixinxi;
import com.example.exception.CustomException;
import com.example.service.BanjixinxiService;
import com.example.vo.BanjixinxiVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;

@Service("banjixinxiService")
public class BanjixinxiServiceImpl extends ServiceImpl<BanjixinxiDao, Banjixinxi> implements BanjixinxiService {

    @Resource
    private BanjixinxiDao banjixinxiDao;

    public Banjixinxi add(Banjixinxi banjixinxi) {
		
	   //youquchong1
        banjixinxi.setAddtime(new Date());
        banjixinxiDao.insert(banjixinxi);
        return banjixinxi;
    }
	
	
	
    public void delete(Long id) {
        banjixinxiDao.deleteById(id);
    }
	

    public void update(Banjixinxi banjixinxi) {
        //youquchong2
        banjixinxiDao.updateById(banjixinxi);
    }
	
	@Override
    public List<Map<String, Object>> daochuexcel() {
        return banjixinxiDao.daochuexcel();
    }

    @Override
    public Banjixinxi findById(Integer id) {
        return banjixinxiDao.selectById(id);
    }

    public BanjixinxiVo findPage(BanjixinxiVo banjixinxiVo) {
        LambdaQueryWrapper<Banjixinxi> wrapper = Wrappers.lambdaQuery();
		wrapper.like(ObjectUtils.isNotEmpty(banjixinxiVo.getBanji()), Banjixinxi::getBanji,banjixinxiVo.getBanji());        wrapper.like(ObjectUtils.isNotEmpty(banjixinxiVo.getBeizhu()), Banjixinxi::getBeizhu,banjixinxiVo.getBeizhu());        
        Page<Banjixinxi> page = new Page<>(banjixinxiVo.getCurrent(),banjixinxiVo.getCurrentNum());
        banjixinxiDao.selectPage(page,wrapper);
        List<Banjixinxi> banjixinxis = page.getRecords();
        banjixinxiVo.setList(banjixinxis);
        banjixinxiVo.setPages(page.getPages());
        banjixinxiVo.setTotal(page.getTotal());
        banjixinxiVo.setCurrent(page.getCurrent());
        banjixinxiVo.setCurrentNum(page.getSize());
        return banjixinxiVo;
    }

    @Override
    public void deleteList(List<Banjixinxi> list) {
        List<Integer> ids =  list.stream().map(Banjixinxi::getId).collect(Collectors.toList());
        banjixinxiDao.deleteBatchIds(ids);
    }
	
	
	
	
	
	//youxxianxci
}
