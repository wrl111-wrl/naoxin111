package com.example.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.entity.Jiaoshixinxi;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface JiaoshixinxiDao extends BaseMapper<Jiaoshixinxi> {

@Select("select * from jiaoshixinxi")
List<Map<String, Object>> daochuexcel();

//youxxianxci

@Select("SELECT distinct(xingbie) as aa,count(id) as bb FROM jiaoshixinxi group by xingbie order by id")List<Map<String, Object>> jiaoshixinxi_tj_xingbie();//tonxgji1

}
