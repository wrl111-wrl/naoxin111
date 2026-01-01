package com.example.service.impl;

import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.common.ResultCode;
import com.example.dao.*;
import com.example.entity.Qingjiashenqing;
import com.example.exception.CustomException;
import com.example.service.QingjiashenqingService;
import com.example.vo.QingjiashenqingVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;

@Service("qingjiashenqingService")
public class QingjiashenqingServiceImpl extends ServiceImpl<QingjiashenqingDao, Qingjiashenqing> implements QingjiashenqingService {

    @Resource
    private QingjiashenqingDao qingjiashenqingDao;

    public Qingjiashenqing add(Qingjiashenqing qingjiashenqing) {
		
	   //youquchong1
        qingjiashenqing.setAddtime(new Date());
        qingjiashenqingDao.insert(qingjiashenqing);
        return qingjiashenqing;
    }
	
	
	
    public void delete(Long id) {
        qingjiashenqingDao.deleteById(id);
    }
	

    public void update(Qingjiashenqing qingjiashenqing) {
        //youquchong2
        qingjiashenqingDao.updateById(qingjiashenqing);
    }
	
	@Override
    public List<Map<String, Object>> daochuexcel() {
        return qingjiashenqingDao.daochuexcel();
    }

    @Override
    public Qingjiashenqing findById(Integer id) {
        return qingjiashenqingDao.selectById(id);
    }

    public QingjiashenqingVo findPage(QingjiashenqingVo qingjiashenqingVo) {
        LambdaQueryWrapper<Qingjiashenqing> wrapper = Wrappers.lambdaQuery();
		wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getQingjiabianhao()), Qingjiashenqing::getQingjiabianhao,qingjiashenqingVo.getQingjiabianhao());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getXuehao()), Qingjiashenqing::getXuehao,qingjiashenqingVo.getXuehao());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getXueshengxingming()), Qingjiashenqing::getXueshengxingming,qingjiashenqingVo.getXueshengxingming());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getLianxidianhua()), Qingjiashenqing::getLianxidianhua,qingjiashenqingVo.getLianxidianhua());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getBanji()), Qingjiashenqing::getBanji,qingjiashenqingVo.getBanji());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getQingjiayuanyin()), Qingjiashenqing::getQingjiayuanyin,qingjiashenqingVo.getQingjiayuanyin());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getQishishijian()), Qingjiashenqing::getQishishijian,qingjiashenqingVo.getQishishijian());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getZhongzhishijian()), Qingjiashenqing::getZhongzhishijian,qingjiashenqingVo.getZhongzhishijian());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getBeizhu()), Qingjiashenqing::getBeizhu,qingjiashenqingVo.getBeizhu());        wrapper.like(ObjectUtils.isNotEmpty(qingjiashenqingVo.getIssh()), Qingjiashenqing::getIssh,qingjiashenqingVo.getIssh());        
        Page<Qingjiashenqing> page = new Page<>(qingjiashenqingVo.getCurrent(),qingjiashenqingVo.getCurrentNum());
        qingjiashenqingDao.selectPage(page,wrapper);
        List<Qingjiashenqing> qingjiashenqings = page.getRecords();
        qingjiashenqingVo.setList(qingjiashenqings);
        qingjiashenqingVo.setPages(page.getPages());
        qingjiashenqingVo.setTotal(page.getTotal());
        qingjiashenqingVo.setCurrent(page.getCurrent());
        qingjiashenqingVo.setCurrentNum(page.getSize());
        return qingjiashenqingVo;
    }

    @Override
    public void deleteList(List<Qingjiashenqing> list) {
        List<Integer> ids =  list.stream().map(Qingjiashenqing::getId).collect(Collectors.toList());
        qingjiashenqingDao.deleteBatchIds(ids);
    }
	
	
	
	
	
	//youxxianxci
}
