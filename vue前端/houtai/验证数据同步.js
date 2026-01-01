const axios = require('axios');

// 验证学生数据同步状态
async function verifyDataSync() {
    console.log('🔍 验证学生数据同步状态...\n');

    try {
        // 1. 测试获取学生列表API
        console.log('📊 测试学生数据API...');
        
        const response = await axios.get('http://localhost:8888/xueshengxinxi/list', {
            headers: {
                'Content-Type': 'application/json'
            },
            timeout: 5000
        });

        console.log('✅ 后端API响应成功！');
        console.log('📋 响应数据:', JSON.stringify(response.data, null, 2));

        if (response.data && response.data.data) {
            const studentList = response.data.data;
            console.log(`\n📈 学生数据统计:`);
            console.log(`   - 总数量: ${studentList.length} 个学生`);
            
            if (studentList.length > 0) {
                console.log(`   - 第一个学生: ${studentList[0].xueshengxingming} (学号: ${studentList[0].xuehao})`);
                console.log(`   - 最后一个学生: ${studentList[studentList.length - 1].xueshengxingming} (学号: ${studentList[studentList.length - 1].xuehao})`);
                
                // 检查性别字段
                const genderStats = {};
                studentList.forEach(student => {
                    const gender = student.xingbie;
                    genderStats[gender] = (genderStats[gender] || 0) + 1;
                });
                
                console.log(`\n👥 性别分布:`);
                Object.entries(genderStats).forEach(([gender, count]) => {
                    console.log(`   - ${gender}: ${count} 人`);
                });
                
                // 检查是否达到50个学生
                if (studentList.length >= 50) {
                    console.log(`\n✅ 验证成功！已有 ${studentList.length} 个学生数据`);
                } else {
                    console.log(`\n⚠️  学生数量不足，当前仅有 ${studentList.length} 个，需要50个`);
                }
            }
        }

    } catch (error) {
        console.error('❌ 验证失败:', error.message);
        if (error.response) {
            console.error('响应状态:', error.response.status);
            console.error('响应数据:', error.response.data);
        }
    }
}

// 执行验证
verifyDataSync();