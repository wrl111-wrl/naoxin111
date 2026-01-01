package com.example.service;


import com.baomidou.mybatisplus.extension.service.IService;
import com.example.entity.Qingjiashenqing;
import com.example.vo.QingjiashenqingVo;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface QingjiashenqingService extends IService<Qingjiashenqing> {
    Qingjiashenqing add(Qingjiashenqing qingjiashenqing);
    void delete(Long id);
    void update(Qingjiashenqing qingjiashenqing);
    Qingjiashenqing findById(Integer id);
    QingjiashenqingVo findPage(QingjiashenqingVo qingjiashenqingVo);
    int theDayNum();
	
    void deleteList(List<Qingjiashenqing> list);
	
	
	List<Map<String, Object>> daochuexcel();

    List<Map<String, Object>> getError();
    //youxxianxci
}
