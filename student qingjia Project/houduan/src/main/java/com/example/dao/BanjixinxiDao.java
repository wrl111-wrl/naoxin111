package com.example.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.entity.Banjixinxi;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface BanjixinxiDao extends BaseMapper<Banjixinxi> {

@Select("select * from banjixinxi")
List<Map<String, Object>> daochuexcel();

//youxxianxci

//tonxgji1

}
