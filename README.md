<div align="center">
  <img src="./Resources/clipy_logo.png" width="400">
</div>

# Clipy 增强版

> 原版 Clipy 的增强分支，支持微信/钉钉截图自动捕获

[![Release version](https://img.shields.io/github/release/ZJM6658/Guapy.svg)](https://github.com/ZJM6658/Guapy/releases/latest)
![macOS](https://img.shields.io/badge/macOS-10.13%2B-blue.svg)

---

## 📖 关于本项目

本项目是基于 [Clipy/Clipy](https://github.com/Clipy/Clipy) 的 **Fork 增强版本**。

Clipy 是一款优秀的 macOS 剪贴板扩展应用，本版本在保留原版所有功能的基础上，新增了**剪贴板图片监听**功能，解决了原版无法捕获微信、钉钉等应用快捷截图的问题。

### 🔗 原项目

- **原版仓库**: [Clipy/Clipy](https://github.com/Clipy/Clipy)
- **原版 README**: [查看原文](https://github.com/Clipy/Clipy/blob/master/README.md)

---

## ✨ 新增功能

### 🎯 剪贴板图片监听

原版 Clipy 只能通过监听桌面文件夹来捕获系统截图（Cmd+Shift+4），无法捕获微信、钉钉等应用的快捷截图。本版本通过直接监听剪贴板图片变化来解决这个问题。

#### 支持的截图方式

| 截图来源 | 快捷键 | 状态 |
|---------|-------|------|
| 微信 | `Cmd + Ctrl + A` | ✅ 支持 |
| 钉钉 | 快捷截图 | ✅ 支持 |
| 系统 | `Cmd + Shift + 4/5` | ✅ 支持 |
| 其他 | 任何复制图片的操作 | ✅ 支持 |

#### 功能特性

- **自动去重**: 相同图片不会重复保存
- **智能过滤**: 只处理纯图片内容，避免误捕获
- **可配置**: 支持通过设置开关此功能
- **遵守规则**: 尊重应用排除设置

#### 技术实现

- 使用 RxSwift 扩展监听剪贴板图片变化
- 基于图片数据哈希进行去重
- 新增 Beta 功能开关：`observerClipboardImage`

---

## 📦 下载安装

### 系统要求

- **操作系统**: macOS 10.13 (High Sierra) 或更高版本
- **权限**: 需要授予辅助功能权限

### 安装步骤

1. 从 [Releases](https://github.com/ZJM6658/Guapy/releases) 下载最新版本
2. 解压并将 `Clipy.app` 拖到 `应用程序` 文件夹
3. 首次运行时，在系统偏好设置中授予辅助功能权限
4. 启动应用，菜单栏会出现 Clipy 图标

### 配置剪贴板图片监听

该功能默认已启用。如需配置：

1. 打开 Clipy 偏好设置
2. 选择 "Beta" 标签页
3. 在 "Screenshot" 部分找到 "Save clipboard images (WeChat, DingTalk, etc.)"
4. 勾选或取消勾选该选项

---

## 🛠️ 开发构建

### 开发环境

- **macOS**: 10.15+ (Catalina 或更高版本)
- **Xcode**: 12.2 或更高版本
- **Swift**: 5.3
- **Ruby**: 2.7+ (用于 CocoaPods)

### 构建步骤

```bash
# 1. 安装依赖
bundle install --path=vendor/bundle && bundle exec pod install

# 2. 打开工作空间
open Clipy.xcworkspace

# 3. 选择目标设备并构建
# 在 Xcode 中按 Cmd + B 构建，或按 Cmd + R 运行
```

### 命令行构建

```bash
# Debug 版本
xcodebuild -workspace Clipy.xcworkspace -scheme Clipy -configuration Debug build

# Release 版本
xcodebuild -workspace Clipy.xcworkspace -scheme Clipy -configuration Release build
```

---

## 📝 更新日志

### v1.3.0 (2024-12-27)

#### 新增功能
- ✨ 添加剪贴板图片监听功能，支持微信/钉钉截图捕获
- ✨ 新增 RxSwift 扩展 `NSPasteboard+RxImage`
- ✨ 添加图片去重机制，避免重复保存

#### 功能改进
- 🔧 更新部署目标至 macOS 10.13
- 🔧 移除测试依赖以兼容 Xcode 16
- 🔧 优化代码结构和项目文档

#### 完整提交记录
- feat: add clipboard image monitoring RxSwift extension
- feat: add Beta feature toggle for clipboard image monitoring
- feat: add image deduplication to prevent duplicate clips
- feat: integrate clipboard image monitoring in AppDelegate
- build: update deployment target to macOS 10.13
- docs: add project documentation for Claude Code

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

如果您想贡献代码：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b my-new-feature`)
3. 提交更改 (`git commit -am 'Add some feature'`)
4. 推送到分支 (`git push origin my-new-feature`)
5. 创建 Pull Request

---

## 📄 许可证

本项目继承原项目的 [MIT License](LICENSE)。

**重要提示**: 根据 Clipy 原项目的分发要求：

1. 请勿使用 `Clipy` 和 `ClipMenu` 作为您的产品名称
2. 必须遵守 MIT 许可证条款

---

## 🙏 致谢

### 原项目

- [Clipy/Clipy](https://github.com/Clipy/Clipy) - 优秀的剪贴板扩展应用
- [naotaka/ClipMenu](https://github.com/naotaka/ClipMenu) - Clipy 的灵感来源

### 主要依赖

- [RealmSwift](https://github.com/realm/realm-swift) - 数据库
- [RxSwift](https://github.com/ReactiveX/RxSwift) - 响应式编程
- [Magnet](https://github.com/Clipy/Magnet) - 全局快捷键
- [Sparkle](https://github.com/sparkle-project/Sparkle) - 自动更新
- [Screeen](https://github.com/Clipy/Screeen) - 截图监听

---

## 📮 联系方式

- **Issues**: [GitHub Issues](https://github.com/ZJM6658/Guapy/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ZJM6658/Guapy/discussions)

---

<div align="center">

**如果这个项目对您有帮助，请给个 ⭐ Star**

Made with ❤️ by [ZJM6658](https://github.com/ZJM6658)

</div>
