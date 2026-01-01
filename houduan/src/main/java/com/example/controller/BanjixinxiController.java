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
import com.example.entity.Banjixinxi;
import com.example.exception.CustomException;
import com.example.service.BanjixinxiService;
import com.example.utils.MapWrapperUtils;
import com.example.utils.jwt.JwtUtil;
import com.example.vo.BanjixinxiVo;
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
@RequestMapping(value = "/banjixinxi")
public class BanjixinxiController {

    @Resource
    private BanjixinxiService banjixinxiService;

    @PostMapping
    public Result<Banjixinxi> add(@RequestBody BanjixinxiVo banjixinxi) {
		//yoxuxiaxnci
        banjixinxiService.add(banjixinxi);
        return Result.success(banjixinxi);
    }
	
	
    @GetMapping("/getExcel")
    public void getExcel(HttpServletResponse response) throws IOException {
        // 1. 生成excel
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("banji","班级");        row.put("beizhu","备注");        

        row.put("addtime","添加时间");
        List<Map<String, Object>> list = CollUtil.newArrayList(row);
        List<Map<String, Object>> daochuexcellist = banjixinxiService.daochuexcel();
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
    public Result<Banjixinxi> deleteList(@RequestBody BanjixinxiVo banjixinxi) {
        banjixinxiService.deleteList(banjixinxi.getList());
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        banjixinxiService.delete(id);
        return Result.success();
    }

    @PutMapping
    public Result update(@RequestBody BanjixinxiVo banjixinxi) {
        banjixinxiService.update(banjixinxi);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Banjixinxi> detail(@PathVariable Integer id) {
        Banjixinxi banjixinxi = banjixinxiService.findById(id);
        return Result.success(banjixinxi);
    }

    @GetMapping
    public Result<List<Banjixinxi>> all() {
        return Result.success(banjixinxiService.list());
    }

    @PostMapping("/page")
    public Result<BanjixinxiVo> page(@RequestBody BanjixinxiVo banjixinxiVo) {
        return Result.success(banjixinxiService.findPage(banjixinxiVo));
    }
	
	@PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file) throws IOException {
        ExcelReader reader = ExcelUtil.getReader(file.getInputStream());
        List<Banjixinxi> banjixinxis = reader.readAll(Banjixinxi.class);
		
        banjixinxiService.saveBatch(banjixinxis);
        return Result.success();
    }
	
	//youupdt2login
}
