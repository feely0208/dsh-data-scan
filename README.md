# @deepwhale-cn/dsh-data-scan

[![Listed on dsh-plugin.org](https://dsh-plugin.org/badges/listed.svg)](https://dsh-plugin.org/plugins/feely0208/dsh-data-scan)


**关键词**：敏感数据 · 个人信息 · 身份证号 · 银行卡号 · 手机号 · 数据泄露 · 隐私数据 · 个人信息保护法 · PII
**Keywords**: sensitive data · PII · personal information · ID card · bank card · phone number · data leak
**敏感数据发现** —— 扫出代码和配置里的身份证、银行卡、手机号。

**带校验位验证**，不是纯正则。

## 不装它会怎样

你为了调试方便，把一段**真实的用户数据**放进了测试文件，然后提交了。

仓库后来开源了。三个月后有人告诉你：**那批身份证号能被搜到**。

这个检查跑一次几秒钟。

## 它查什么

| 级别 | 类型 | 校验 |
|---|---|---|
| 🔴 高 | 身份证号 | GB 11643-1999 **加权校验位** |
| 🔴 高 | 银行卡号 | **Luhn 算法** |
| 🟡 中 | 手机号 | 号段 + **边界断言** |
| 🟢 低 | 邮箱 | 结构匹配（提示性质）|

## 为什么值得用（不是「正则扫一遍」）

纯正则会误报一堆：订单号、时间戳、版本号、哈希片段都像。
被误报烦几次你就不会再用这个工具了。

本工具做**结构 + 校验位**双重验证：

```
✅ 11010519491231002X   身份证，校验位对
❌ 11010519491231003X   校验位错 → 不报
✅ 4532015112830366     卡号，Luhn 过
❌ 4532015112830367     改一位 → 不报
❌ 138123456789012345   像手机但 18 位 → 不报
```

## 输出永不含原值

只报「文件:行 + 类型 + 打码片段」。**记原值等于让扫描工具自己成为泄露源。**

## 安装

```bash
dsh plugin --profile web add @deepwhale-cn/dsh-data-scan
# 或纯 CLI
npx @deepwhale-cn/dsh-data-scan
```

## 用法

```bash
dsh-data-scan                 # 扫当前目录
dsh-data-scan --demo          # 看检出效果
dsh-data-scan --html r.html   # HTML 报告
```

![dsh-data-scan 的检查报告示例](https://www.deepwhale.org.cn/plugin-assets/dsh-data-scan/report.png)

## 边界

- **不扫二进制/图片** —— 截图里的身份证、PDF 里的表格扫不到。
- **不查 .git 历史** —— 只看到当前工作区，已提交过的需另做历史清理。
- 与 [dsh-secret-scan](https://github.com/feely0208/dsh-cn-skills) **不重叠**：那个查密钥，这个查个人信息。

本插件是一个工具。使用者必须遵守所在地区法律法规，**对使用本项目造成的任何后果自行承担责任。**

## License

MIT © 深鲸 DeepWhale
