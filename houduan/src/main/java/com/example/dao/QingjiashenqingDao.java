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
    @Select("SELECT COUNT(*) FROM qingjiashenqing WHERE DATE(addtime) = CURDATE()")
    int theDayNum();
    @Select("<script>" +
            "SELECT " +
            "    xueshengxingming, " +
            "    COUNT(*) as leave_count, " +
            "    GROUP_CONCAT(DATE_FORMAT(qishishijian, '%Y-%m-%d') SEPARATOR ', ') as leave_dates " +
            "FROM qingjiashenqing " +
            "WHERE " +
            "    addtime >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
            "    AND issh != '已撤销' " +
            "GROUP BY xuehao, xueshengxingming, banji " +
            "HAVING COUNT(*) >= 3 " +
            "ORDER BY leave_count DESC" +
            "</script>")
    List<Map<String, Object>> getError();

//youxxianxci

//tonxgji1

}
