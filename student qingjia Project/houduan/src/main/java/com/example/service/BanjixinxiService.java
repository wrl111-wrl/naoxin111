package com.example.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.example.entity.Banjixinxi;
import com.example.vo.BanjixinxiVo;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface BanjixinxiService extends IService<Banjixinxi> {
    Banjixinxi add(Banjixinxi banjixinxi);
    void delete(Long id);
    void update(Banjixinxi banjixinxi);
    Banjixinxi findById(Integer id);
    BanjixinxiVo findPage(BanjixinxiVo banjixinxiVo);
	
    void deleteList(List<Banjixinxi> list);
	
	
	List<Map<String, Object>> daochuexcel();
	//youxxianxci
}
