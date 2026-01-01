package com.example.controller;
import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.date.DatePattern;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.example.common.Result;
import com.example.common.ResultCode;
import com.example.entity.Qingjiashenqing;
import com.example.exception.CustomException;
import com.example.service.QingjiashenqingService;
import com.example.utils.MapWrapperUtils;
import com.example.utils.jwt.JwtUtil;
import com.example.vo.QingjiashenqingVo;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

import cn.hutool.poi.excel.ExcelReader;
import org.springframework.web.multipart.MultipartFile;
import java.util.function.Function;
import java.util.stream.Collectors;

@RestController
@RequestMapping(value = "/qingjiashenqing")
public class QingjiashenqingController {

    @Resource
    private QingjiashenqingService qingjiashenqingService;

    @PostMapping
    public Result<Qingjiashenqing> add(@RequestBody QingjiashenqingVo qingjiashenqing) {
		//yoxuxiaxnci

        qingjiashenqingService.add(qingjiashenqing);
        return Result.success(qingjiashenqing);
    }
    @GetMapping("/error")
    public Result<Object> error() {
        return Result.success(qingjiashenqingService.getError());
    }
	
	
    @GetMapping("/getExcel")
    public void getExcel(HttpServletResponse response) throws IOException {
        // 1. 生成excel
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("qingjiabianhao","请假编号");
        row.put("xuehao","学号");
        row.put("xueshengxingming","学生姓名");
        row.put("lianxidianhua","联系电话");
        row.put("banji","班级");
        row.put("qingjiayuanyin","请假原因");
        row.put("qishishijian","起始时间");
        row.put("zhongzhishijian","终止时间");
        row.put("beizhu","备注");
        

        row.put("addtime","添加时间");
        List<Map<String, Object>> list = CollUtil.newArrayList(row);
        List<Map<String, Object>> daochuexcellist = qingjiashenqingService.daochuexcel();
        for (Map<String, Object> map : daochuexcellist) {
            list.add(map);
        }
        // 2. 写excel
        ExcelWriter writer = ExcelUtil.getWriter(true);
        writer.write(list, true);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        response.setHeader("Content-Disposition","attachment;filename=chaoba.xlsx");
        ServletOutputStream out = response.getOutputStream();
        writer.flush(out, true);
        writer.close();
        IoUtil.close(System.out);
    }
	
	

    @PostMapping("/deleteList")
    public Result<Qingjiashenqing> deleteList(@RequestBody QingjiashenqingVo qingjiashenqing) {
        qingjiashenqingService.deleteList(qingjiashenqing.getList());
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        qingjiashenqingService.delete(id);
        return Result.success();
    }

    @PutMapping
    public Result update(@RequestBody QingjiashenqingVo qingjiashenqing) {
        qingjiashenqingService.update(qingjiashenqing);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Qingjiashenqing> detail(@PathVariable Integer id) {
        Qingjiashenqing qingjiashenqing = qingjiashenqingService.findById(id);
        return Result.success(qingjiashenqing);
    }

    @GetMapping
    public Result<List<Qingjiashenqing>> all() {
        return Result.success(qingjiashenqingService.list());
    }

    @PostMapping("/page")
    public Result<QingjiashenqingVo> page(@RequestBody QingjiashenqingVo qingjiashenqingVo) {
        return Result.success(qingjiashenqingService.findPage(qingjiashenqingVo));
    }
	
	@PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file) throws IOException {
        ExcelReader reader = ExcelUtil.getReader(file.getInputStream());
        List<Qingjiashenqing> qingjiashenqings = reader.readAll(Qingjiashenqing.class);
		
        qingjiashenqingService.saveBatch(qingjiashenqings);
        return Result.success();
    }
	
	//youupdt2login
}
