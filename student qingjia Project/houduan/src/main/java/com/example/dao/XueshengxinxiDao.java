package com.example.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.entity.Xueshengxinxi;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface XueshengxinxiDao extends BaseMapper<Xueshengxinxi> {

@Select("select * from xueshengxinxi")
List<Map<String, Object>> daochuexcel();

//youxxianxci

@Select("SELECT distinct(xingbie) as aa,count(id) as bb FROM xueshengxinxi group by xingbie order by id")List<Map<String, Object>> xueshengxinxi_tj_xingbie();@Select("SELECT distinct(banji) as aa,count(id) as bb FROM xueshengxinxi group by banji order by id")List<Map<String, Object>> xueshengxinxi_tj_banji();//tonxgji1

}
