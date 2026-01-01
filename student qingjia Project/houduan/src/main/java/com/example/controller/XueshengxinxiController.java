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
import com.example.entity.Xueshengxinxi;
import com.example.exception.CustomException;
import com.example.service.XueshengxinxiService;
import com.example.utils.MapWrapperUtils;
import com.example.utils.jwt.JwtUtil;
import com.example.vo.XueshengxinxiVo;
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
@RequestMapping(value = "/xueshengxinxi")
public class XueshengxinxiController {

    @Resource
    private XueshengxinxiService xueshengxinxiService;

    @PostMapping
    public Result<Xueshengxinxi> add(@RequestBody XueshengxinxiVo xueshengxinxi) {
		//yoxuxiaxnci
        xueshengxinxiService.add(xueshengxinxi);
        return Result.success(xueshengxinxi);
    }
	
	
    @GetMapping("/getExcel")
    public void getExcel(HttpServletResponse response) throws IOException {
        // 1. 生成excel
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("xuehao","学号");
        row.put("xueshengxingming","学生姓名");
        row.put("xingbie","性别");
        row.put("shenfenzheng","身份证");
        row.put("dianhua","电话");
        row.put("banji","班级");
        row.put("jiguan","籍贯");
        row.put("beizhu","备注");
        

        row.put("addtime","添加时间");
        List<Map<String, Object>> list = CollUtil.newArrayList(row);
        List<Map<String, Object>> daochuexcellist = xueshengxinxiService.daochuexcel();
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
	
	@GetMapping("/xueshengxinxi_tj_xingbie")
    public Result xueshengxinxi_tj_xingbie() {
        return Result.success(xueshengxinxiService.xueshengxinxi_tj_xingbie());
    }
    @GetMapping("/xueshengxinxi_tj_banji")
    public Result xueshengxinxi_tj_banji() {
        return Result.success(xueshengxinxiService.xueshengxinxi_tj_banji());
    }
    

    @PostMapping("/deleteList")
    public Result<Xueshengxinxi> deleteList(@RequestBody XueshengxinxiVo xueshengxinxi) {
        xueshengxinxiService.deleteList(xueshengxinxi.getList());
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        xueshengxinxiService.delete(id);
        return Result.success();
    }

    @PutMapping
    public Result update(@RequestBody XueshengxinxiVo xueshengxinxi) {
        xueshengxinxiService.update(xueshengxinxi);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Xueshengxinxi> detail(@PathVariable Integer id) {
        Xueshengxinxi xueshengxinxi = xueshengxinxiService.findById(id);
        return Result.success(xueshengxinxi);
    }

    @GetMapping
    public Result<List<Xueshengxinxi>> all() {
        return Result.success(xueshengxinxiService.list());
    }

    @PostMapping("/page")
    public Result<XueshengxinxiVo> page(@RequestBody XueshengxinxiVo xueshengxinxiVo) {
        return Result.success(xueshengxinxiService.findPage(xueshengxinxiVo));
    }
	
	@PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file) throws IOException {
        ExcelReader reader = ExcelUtil.getReader(file.getInputStream());
        List<Xueshengxinxi> xueshengxinxis = reader.readAll(Xueshengxinxi.class);
		for (Xueshengxinxi xueshengxinxi : xueshengxinxis) { xueshengxinxi.setMima("e10adc3949ba59abbe56e057f20f883e");}
        xueshengxinxiService.saveBatch(xueshengxinxis);
        return Result.success();
    }
	
	    @PostMapping("/login")
    public Result login(@RequestBody Xueshengxinxi xueshengxinxi, HttpServletRequest request) {
        if (StrUtil.isBlank(xueshengxinxi.getXuehao()) || StrUtil.isBlank(xueshengxinxi.getMima())) {
            throw new CustomException(ResultCode.PARAM_LOST_ERROR);
        }
        Xueshengxinxi login = xueshengxinxiService.login(xueshengxinxi);
//        if(!login.getStatus()){
//            return Result.error("1001","状态限制，无法登录系统");
//        }
        if(login != null) {
            HashMap hashMap = new HashMap();
            hashMap.put("user", login);
            Map<String, Object> map = MapWrapperUtils.builder(MapWrapperUtils.KEY_USER_ID,xueshengxinxi.getId());
            String token = JwtUtil.creatToken(map);
            hashMap.put("token", token);
            return Result.success(hashMap);
        }else {
            return Result.error();
        }
    }
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Xueshengxinxi info, HttpServletRequest request) {
        Xueshengxinxi xueshengxinxi = xueshengxinxiService.findById(info.getId());
        String oldPassword = SecureUtil.md5(info.getMima());
        if (!oldPassword.equals(xueshengxinxi.getMima())) {
            return Result.error(ResultCode.PARAM_PASSWORD_ERROR.code, ResultCode.PARAM_PASSWORD_ERROR.msg);
        }
        info.setMima(SecureUtil.md5(info.getNewPassword()));
        Xueshengxinxi xueshengxinxi1 = new Xueshengxinxi();
        BeanUtils.copyProperties(info, xueshengxinxi1);
        xueshengxinxiService.update(xueshengxinxi1);
        return Result.success();
    }
	@PostMapping("/register")
    public Result<Xueshengxinxi> register(@RequestBody XueshengxinxiVo xueshengxinxi) {
        xueshengxinxiService.add(xueshengxinxi);
        return Result.success(xueshengxinxi);
    }
}
