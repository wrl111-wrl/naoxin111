package com.example.controller;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import lombok.extern.slf4j.Slf4j;
import java.nio.charset.StandardCharsets;
import java.util.Set;
import java.util.HashSet;

@Slf4j
@RestController
//@CrossOrigin(origins = "*", allowedHeaders = "*")
public class JsonFileController {

    // 定义允许访问的JSON文件名白名单
    private static final Set<String> ALLOWED_FILES = new HashSet<>();

    static {
        ALLOWED_FILES.add("guanliyuan");
        ALLOWED_FILES.add("jiaoshi");
        ALLOWED_FILES.add("xuesheng");
        // 可以在这里添加其他允许的文件名
    }

    /**
     * 直接映射特定JSON文件 - 管理员菜单
     */
    @GetMapping(value = "/guanliyuan.json", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Resource> getGuanliyuanJson() {
        return getJsonFile("guanliyuan");
    }

    /**
     * 教师菜单
     */
    @GetMapping(value = "/jiaoshi.json", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Resource> getJiaoshiJson() {
        return getJsonFile("jiaoshi");
    }

    /**
     * 学生菜单
     */
    @GetMapping(value = "/xuesheng.json", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Resource> getXueshengJson() {
        return getJsonFile("xuesheng");
    }

    /**
     * 动态获取JSON文件
     * 支持的文件名: guanliyuan.json, jiaoshi.json, xuesheng.json 等
     */
    @GetMapping(value = "/{filename}.json", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Resource> getJsonFile(@PathVariable String filename) {
        try {
            log.info("请求JSON文件: {}.json", filename);

            // 安全检查：防止路径遍历攻击
            if (!isValidFilename(filename)) {
                log.warn("无效的文件名: {}", filename);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(null);
            }

            // 从classpath的static目录下加载文件
            String filePath = "static/" + filename + ".json";
            Resource resource = new ClassPathResource(filePath);

            if (!resource.exists()) {
                log.warn("JSON文件不存在: {}.json", filename);
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .header("X-File-Error", "File not found")
                        .body(null);
            }

            if (!resource.isReadable()) {
                log.warn("JSON文件不可读: {}.json", filename);
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .header("X-File-Error", "File not readable")
                        .body(null);
            }

            log.info("成功返回JSON文件: {}.json", filename);

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .header(HttpHeaders.CACHE_CONTROL, "no-cache, no-store, must-revalidate")
                    .header(HttpHeaders.PRAGMA, "no-cache")
                    .header(HttpHeaders.EXPIRES, "0")
                    .header("X-File-Name", filename + ".json")
                    .body(resource);

        } catch (Exception e) {
            log.error("读取JSON文件失败: {}.json", filename, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .header("X-Error-Message", "Internal server error")
                    .body(null);
        }
    }

    /**
     * 验证文件名是否合法
     * 1. 检查文件名是否为空
     * 2. 检查文件名是否在白名单中
     * 3. 防止路径遍历攻击（../, ./ 等）
     *
     * @param filename 要验证的文件名
     * @return 如果文件名合法返回true，否则返回false
     */
    private boolean isValidFilename(String filename) {
        if (filename == null || filename.trim().isEmpty()) {
            return false;
        }

        // 防止路径遍历攻击
        if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
            return false;
        }

        // 检查文件名是否在白名单中
        return ALLOWED_FILES.contains(filename.toLowerCase());
    }

    /**
     * 更严格的文件名验证（可选）
     * 只允许字母、数字、下划线和连字符
     */
    private boolean isValidFilenameStrict(String filename) {
        if (filename == null || filename.trim().isEmpty()) {
            return false;
        }

        // 只允许字母、数字、下划线和连字符
        if (!filename.matches("^[a-zA-Z0-9_-]+$")) {
            return false;
        }

        // 检查文件名是否在白名单中
        return ALLOWED_FILES.contains(filename.toLowerCase());
    }
}