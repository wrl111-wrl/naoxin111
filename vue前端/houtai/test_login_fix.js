const axios = require('axios');
const crypto = require('crypto');

async function testLoginAndFix() {
    try {
        console.log('🔍 测试管理员登录...');
        
        // 测试不同密码
        const passwords = ['admin', '123456', 'password'];
        
        for (const password of passwords) {
            const passwordMD5 = crypto.createHash('md5').update(password).digest('hex');
            console.log(`\n🔑 测试密码: "${password}"`);
            console.log(`   MD5哈希值: ${passwordMD5}`);
            
            try {
                const response = await axios.post('http://localhost:8888/guanliyuan/login', {
                    yonghuming: 'admin',
                    mima: password
                }, {
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    timeout: 5000
                });
                
                console.log(`   ✅ 登录成功！`);
                console.log(`   响应:`, response.data);
                
                if (response.data && response.data.data && response.data.data.token) {
                    console.log(`   🎉 获得Token: ${response.data.data.token.substring(0, 20)}...`);
                    return { success: true, username: 'admin', password: password };
                }
                
            } catch (error) {
                console.log(`   ❌ 登录失败: ${error.response?.data?.msg || error.message}`);
            }
        }
        
        console.log('\n💡 建议: 尝试更新数据库中的管理员密码...');
        return { success: false };
        
    } catch (error) {
        console.error('❌ 测试失败:', error.message);
        return { success: false, error: error.message };
    }
}

// 如果直接运行此文件
if (require.main === module) {
    testLoginAndFix().then(result => {
        console.log('\n' + '='.repeat(50));
        console.log('📋 测试结果:');
        console.log(result);
        process.exit(result.success ? 0 : 1);
    });
}

module.exports = { testLoginAndFix };