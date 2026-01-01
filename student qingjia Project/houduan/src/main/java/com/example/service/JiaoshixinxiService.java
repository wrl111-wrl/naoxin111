package com.example.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.example.entity.Jiaoshixinxi;
import com.example.vo.JiaoshixinxiVo;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface JiaoshixinxiService extends IService<Jiaoshixinxi> {
    Jiaoshixinxi add(Jiaoshixinxi jiaoshixinxi);
    void delete(Long id);
    void update(Jiaoshixinxi jiaoshixinxi);
    Jiaoshixinxi findById(Integer id);
    JiaoshixinxiVo findPage(JiaoshixinxiVo jiaoshixinxiVo);
	Jiaoshixinxi login(Jiaoshixinxi jiaoshixinxi);
    void deleteList(List<Jiaoshixinxi> list);
	List<Map<String,Object>> jiaoshixinxi_tj_xingbie();    
	
	List<Map<String, Object>> daochuexcel();
	//youxxianxci
}
