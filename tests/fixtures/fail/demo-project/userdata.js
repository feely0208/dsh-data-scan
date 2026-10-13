// 故意混入真实格式的敏感数据
module.exports = {
  user: {
    name: '张三',
    idcard: '11010519491231002X',
    phone: '13812345678',
    bankcard: '4532015112830366',
    email: 'zhangsan@example.com'
  },
  // 这些不该被报（校验不过 / 不是手机号）
  orderId: '138123456789012345',
  fakeCard: '4532015112830367'
};
