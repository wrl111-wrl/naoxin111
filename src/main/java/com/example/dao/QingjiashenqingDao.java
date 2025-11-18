package com.example.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.entity.Qingjiashenqing;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface QingjiashenqingDao extends BaseMapper<Qingjiashenqing> {

@Select("select * from qingjiashenqing")
List<Map<String, Object>> daochuexcel();

//youxxianxci

//tonxgji1

}
