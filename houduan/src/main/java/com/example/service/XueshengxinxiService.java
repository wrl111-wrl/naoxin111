package com.example.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.example.entity.Xueshengxinxi;
import com.example.vo.XueshengxinxiVo;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface XueshengxinxiService extends IService<Xueshengxinxi> {
    Xueshengxinxi add(Xueshengxinxi xueshengxinxi);
    void delete(Long id);
    void update(Xueshengxinxi xueshengxinxi);
    Xueshengxinxi findById(Integer id);
    XueshengxinxiVo findPage(XueshengxinxiVo xueshengxinxiVo);
	Xueshengxinxi login(Xueshengxinxi xueshengxinxi);
    void deleteList(List<Xueshengxinxi> list);
	List<Map<String,Object>> xueshengxinxi_tj_xingbie();    List<Map<String,Object>> xueshengxinxi_tj_banji();    
	
	List<Map<String, Object>> daochuexcel();
	//youxxianxci
}
