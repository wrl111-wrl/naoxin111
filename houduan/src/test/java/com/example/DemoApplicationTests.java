package com.example;

import com.example.dao.QingjiashenqingDao;
import com.example.entity.Qingjiashenqing;
import com.example.service.QingjiashenqingService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class DemoApplicationTests {
    @Autowired
    private QingjiashenqingService qingjiashenqingService;
    @Test
    void contextLoads() {
        Qingjiashenqing qingjiashenqing = new Qingjiashenqing();

//        System.out.println(qingjiashenqingService.add());
    }

}
