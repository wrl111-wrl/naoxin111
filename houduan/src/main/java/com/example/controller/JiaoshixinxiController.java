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
import com.example.entity.Jiaoshixinxi;
import com.example.exception.CustomException;
import com.example.service.JiaoshixinxiService;
import com.example.utils.MapWrapperUtils;
import com.example.utils.jwt.JwtUtil;
import com.example.vo.JiaoshixinxiVo;
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
@RequestMapping(value = "/jiaoshixinxi")
public class JiaoshixinxiController {

    @Resource
    private JiaoshixinxiService jiaoshixinxiService;

    @PostMapping
    public Result<Jiaoshixinxi> add(@RequestBody JiaoshixinxiVo jiaoshixinxi) {
		//yoxuxiaxnci
        jiaoshixinxiService.add(jiaoshixinxi);
        return Result.success(jiaoshixinxi);
    }
	
	
    @GetMapping("/getExcel")
    public void getExcel(HttpServletResponse response) throws IOException {
        // 1. 生成excel
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("gonghao","工号");
        row.put("xingming","姓名");
        row.put("xingbie","性别");
        row.put("shenfenzheng","身份证");
        row.put("dianhua","电话");
        row.put("zhicheng","职称");
        row.put("zhujiaokecheng","主教课程");
        row.put("banji","班级");
        row.put("jiguan","籍贯");
        row.put("beizhu","备注");
        

        row.put("addtime","添加时间");
        List<Map<String, Object>> list = CollUtil.newArrayList(row);
        List<Map<String, Object>> daochuexcellist = jiaoshixinxiService.daochuexcel();
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
	
	@GetMapping("/jiaoshixinxi_tj_xingbie")
    public Result jiaoshixinxi_tj_xingbie() {
        return Result.success(jiaoshixinxiService.jiaoshixinxi_tj_xingbie());
    }
    

    @PostMapping("/deleteList")
    public Result<Jiaoshixinxi> deleteList(@RequestBody JiaoshixinxiVo jiaoshixinxi) {
        jiaoshixinxiService.deleteList(jiaoshixinxi.getList());
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        jiaoshixinxiService.delete(id);
        return Result.success();
    }

    @PutMapping
    public Result update(@RequestBody JiaoshixinxiVo jiaoshixinxi) {
        jiaoshixinxiService.update(jiaoshixinxi);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Jiaoshixinxi> detail(@PathVariable Integer id) {
        Jiaoshixinxi jiaoshixinxi = jiaoshixinxiService.findById(id);
        return Result.success(jiaoshixinxi);
    }

    @GetMapping
    public Result<List<Jiaoshixinxi>> all() {
        return Result.success(jiaoshixinxiService.list());
    }

    @PostMapping("/page")
    public Result<JiaoshixinxiVo> page(@RequestBody JiaoshixinxiVo jiaoshixinxiVo) {
        return Result.success(jiaoshixinxiService.findPage(jiaoshixinxiVo));
    }
	
	@PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file) throws IOException {
        ExcelReader reader = ExcelUtil.getReader(file.getInputStream());
        List<Jiaoshixinxi> jiaoshixinxis = reader.readAll(Jiaoshixinxi.class);
		for (Jiaoshixinxi jiaoshixinxi : jiaoshixinxis) { jiaoshixinxi.setMima("e10adc3949ba59abbe56e057f20f883e");}
        jiaoshixinxiService.saveBatch(jiaoshixinxis);
        return Result.success();
    }
	
	    @PostMapping("/login")
    public Result login(@RequestBody Jiaoshixinxi jiaoshixinxi, HttpServletRequest request) {
        if (StrUtil.isBlank(jiaoshixinxi.getGonghao()) || StrUtil.isBlank(jiaoshixinxi.getMima())) {
            throw new CustomException(ResultCode.PARAM_LOST_ERROR);
        }
        Jiaoshixinxi login = jiaoshixinxiService.login(jiaoshixinxi);
//        if(!login.getStatus()){
//            return Result.error("1001","状态限制，无法登录系统");
//        }
        if(login != null) {
            HashMap hashMap = new HashMap();
            hashMap.put("user", login);
            Map<String, Object> map = MapWrapperUtils.builder(MapWrapperUtils.KEY_USER_ID,jiaoshixinxi.getId());
            String token = JwtUtil.creatToken(map);
            hashMap.put("token", token);
            return Result.success(hashMap);
        }else {
            return Result.error();
        }
    }
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Jiaoshixinxi info, HttpServletRequest request) {
        Jiaoshixinxi jiaoshixinxi = jiaoshixinxiService.findById(info.getId());
        String oldPassword = SecureUtil.md5(info.getMima());
        if (!oldPassword.equals(jiaoshixinxi.getMima())) {
            return Result.error(ResultCode.PARAM_PASSWORD_ERROR.code, ResultCode.PARAM_PASSWORD_ERROR.msg);
        }
        info.setMima(SecureUtil.md5(info.getNewPassword()));
        Jiaoshixinxi jiaoshixinxi1 = new Jiaoshixinxi();
        BeanUtils.copyProperties(info, jiaoshixinxi1);
        jiaoshixinxiService.update(jiaoshixinxi1);
        return Result.success();
    }
	@PostMapping("/register")
    public Result<Jiaoshixinxi> register(@RequestBody JiaoshixinxiVo jiaoshixinxi) {
        jiaoshixinxiService.add(jiaoshixinxi);
        return Result.success(jiaoshixinxi);
    }
}
