# Whisky Wallpaper

> 免费的原生 macOS 动态壁纸引擎。在桌面图标后面播放 4K 视频，按时轮播文件夹中的壁纸。无订阅、无账号、无遥测 — 只有 AVFoundation + AppKit 直接与你的 Mac 交互。

![macOS 26+](https://img.shields.io/badge/macOS-26%2B-blue) ![Swift 5](https://img.shields.io/badge/Swift-5-orange) ![License: MIT](https://img.shields.io/badge/License-MIT-green) ![Architecture: AppKit + AVFoundation](https://img.shields.io/badge/AppKit%20%2B%20AVFoundation-native-purple)

---

## 功能

- 将 `.mp4` / `.mov` / `.m4v` 视频作为**桌面壁纸**播放，位于图标层下方
- **单文件播放**或**轮播**文件夹，每 5 / 10 / 30 分钟切换
- **所有显示器同步** — 每个屏幕一个无边框 `NSWindow`，插拔显示器时自动重建
- 通过 `AVPlayerLooper` **无缝循环**（循环点不会出现黑帧）
- **睡眠时暂停**，唤醒后自动恢复
- **开机自启** — 重启后无需额外设置
- **点击穿透** — `ignoresMouseEvents = true`，桌面图标照常点击
- 以 `✨` 图标驻留在**菜单栏** — 没有 Dock 图标，不占任务栏空间

## 为什么做这个

Cindori 的 [Backdrop](https://cindori.com/backdrop) 是一个做得很精美的 macOS 动态壁纸应用 — 但它是订阅制收费。实际引擎只有约 625 行简洁的 Swift 代码，调用的是公开的 AVFoundation 和 AppKit API。Whisky Wallpaper 就是那个引擎，免费且开源。

如果你已经在付费使用 Backdrop 且满意，继续用就好 — 他们值这个价。这个项目给那些想要同样体验但不想订阅、偏好 FOSS、或想在此基础上自定义开发的人。

## 安装

### 预编译版（推荐）

从 [Releases 页面](https://github.com/ForceAI-KW/whisky-wallpaper/releases) 下载最新的 `Whisky.Wallpaper.app.zip`，解压后拖到 `/Applications`。

首次启动：右键 → 打开（macOS Gatekeeper 会警告 — 因为是自签名，没有 Developer ID 签名）。第一次允许后，后续启动就不会再拦了。

### 源码编译

```bash
git clone https://github.com/ForceAI-KW/whisky-wallpaper.git
cd whisky-wallpaper
./scripts/install.sh
```

脚本会：编译 Release 版本，如果登录钥匙串里有自签名证书就用它签名（默认证书名 `Ahmad Sharaf Code Signing`，可在 `scripts/install.sh` 中改），否则用 ad-hoc 签名。然后安装到 `/Applications/Whisky Wallpaper.app`，注册为登录项，启动。可重复运行。

**稳定签名 & TCC 授权（v1.2.0+）：** ad-hoc 签名每次编译都变，导致已授予的 TCC 权限（AppleEvents、辅助功能等）每次重装失效。放一个自签名证书到登录钥匙串里，安装脚本就会用它 — 签名标识保持不变，权限永久保留。脚本还会检测签名身份变化，只在需要时调用 `tccutil reset`，迁移时只需一次重新授权。

需要安装 Xcode 或 Command Line Tools。

## 使用

1. 把视频文件放到 `~/Downloads/` — `.mp4` / `.mov` / `.m4v`。4K H.264 60fps 最理想。免费 4K 素材来源：
   - [MoeWalls](https://moewalls.com) — 免费，无需注册，直接下载
   - [MyLiveWallpapers](https://mylivewallpapers.com) — 同上
   - [Pixabay](https://pixabay.com/videos) — 免费，种类更多
2. 点击菜单栏的 `✨` 图标。
3. 通过「选择壁纸文件…」选择文件，或让 app 自动选中文件夹中最大的视频。
4. 可选：开启轮播 → 每 5 / 10 / 30 分钟循环切换文件夹中的所有视频。

就这样。

### 菜单结构

```
✨  正在播放：Astronaut Facing Black Hole
    5 分钟后切换                ← 仅轮播开启时显示
    ──────────────────────────
    选择壁纸文件…                 ⌘O
    选择壁纸文件夹…               ⌘F
    ──────────────────────────
    轮播                      ►   → 关闭
                                    → 每 5 分钟  ✓
                                    → 每 10 分钟
                                    → 每 30 分钟
                                    → ──────
                                    → 立即随机切换   ⌘N
    播放列表（3 个视频）        ►   → Astronaut Facing Black Hole  ✓
                                    → Galactic Horizon
                                    → UFO and Pyramid
    ──────────────────────────
    暂停                         ⌘P
    重新加载壁纸                  ⌘R
    在 Finder 中显示
    锁屏同步：开                  ⌘L
    ──────────────────────────
    退出 Whisky Wallpaper        ⌘Q
```

菜单实时更新：当前播放标题、下次轮播倒计时、当前轮播勾选、当前播放列表勾选。

## 隐私

- **零网络请求**，永远不联网。二进制只链接 `AppKit`、`AVFoundation`、`ServiceManagement`、`UniformTypeIdentifiers` 和 Apple 私有的 `Wallpaper.framework`（锁屏同步用）。没有分析 SDK、没有遥测、没有自动更新、没有远程配置。
- **无需账号。** 它不知道你是谁。
- **不上传文件。** 视频从本地磁盘播放，通过 `UserDefaults` 中存储的安全范围书签访问。

## 架构

七个 Swift 文件。桌面渲染仅使用公开 macOS API。锁屏同步链接 Apple 私有 `Wallpaper.framework`（见下方隐私和系统要求）。

```
WhiskyWallpaper/
├── WhiskyWallpaperApp.swift          @main 入口，交给 AppDelegate
├── AppDelegate.swift                 NSStatusItem 菜单、首次运行、登录项、壁纸激活协调
├── SettingsManager.swift             UserDefaults + 安全范围书签 + isLockScreenSyncEnabled
├── PlaylistManager.swift             文件夹扫描 + 轮播定时器
├── WallpaperPlayer.swift             AVQueuePlayer + AVPlayerLooper，睡眠/唤醒监听
├── WallpaperWindowController.swift   每屏一个 NSWindow @ kCGDesktopWindowLevel
├── AerialInstaller.swift             将视频注册为系统 aerial
└── WallpaperBridge.swift             私有 Wallpaper.framework 桥接（via @_silgen_name）
```

### 关键技术选择

- **`AVPlayerLooper`** 做循环 — 无缝衔接，比朴素的 `seek(.zero)` 方案好（后者每次循环会闪一帧黑屏）。
- **所有显示器共用一个 `AVQueuePlayer`** — 多屏画面同步；AVPlayer 用单条解码管线驱动多个图层。
- **`NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))`** — 窗口在桌面图标后面。`orderFront()` 后重新设置层级，因为 AppKit 有时会在首次显示时把无边框窗口拉到前面。
- **`collectionBehavior: [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenNone]`** — 所有 Space 都显示、Mission Control 不滑动、Cmd+` 窗口循环跳过。
- **`ignoresMouseEvents = true`** — 桌面图标点击穿透。
- **`NSApplication.didChangeScreenParametersNotification`** — 显示器插拔时销毁+重建壁纸窗口。
- **`NSWorkspace.willSleepNotification` / `.didWakeNotification`** — 睡眠时暂停 AVPlayer，唤醒后恢复（除非用户手动暂停了）。

### 设置默认文件夹

首次启动时，会从 `~/Downloads/` 中选**最大的**视频文件 — MoeWalls / Pixabay 等下载的 4K 壁纸通常 50-150MB，会偏向选中"用户刚下载的那个"。如果你把壁纸放在别处，通过「选择壁纸文件夹…」切换。

## 不做的事

- **锁屏播放动态视频。** v2 提供了部分方案：`AerialInstaller` 在系统设置 → 墙纸中注册当前视频，可通过 Apple 的签名 UI 激活；`WallpaperBridge` 设置匹配的静态帧 PNG 作为系统静态壁纸，使锁屏视觉与桌面一致。尚未实现的是通过 Apple 私有 `WallpaperSettingsManager` XPC 接口自动激活（Backdrop 用的是 Cindori Developer ID 签名路径）。通过「锁屏同步：开/关」（⌘L）切换。
- **应用内浏览在线壁纸库。** Whisky Wallpaper 只播放本地文件。去 MoeWalls / Pixabay / 自己拍的视频找素材。
- **不同显示器不同壁纸。** 所有显示器播放同一段视频。可以加 — 但目前不是目标。
- **Touch Bar 花活、小组件、控制中心插件。** 就是个壁纸引擎。

## 系统要求

- **macOS 26**（Tahoe）或更高
- 不算太老的 Mac（任何 Apple Silicon，或有硬件 H.264 解码的 Intel Mac）
- **不需要** Apple 开发者账号 — 自签名（有证书用稳定签名，没有则 ad-hoc）
- **不需要** Backdrop 或其他壁纸应用运行 — 先卸载那些，避免双重壁纸
- **占用说明：** entitlements plist 为空（未沙盒），但应用链接 Apple 私有 `Wallpaper.framework`，开启锁屏同步（默认开）时会把视频副本、PNG 缩略图和元数据写入 `~/Library/Application Support/com.apple.wallpaper/aerials/`。详见 SECURITY.md。

## 卸载

```bash
./scripts/uninstall.sh
```

移除应用、登录项和所有 `com.ahmadsharaf.WhiskyWallpaper` 下的 UserDefaults 痕迹。你的视频文件不动。

## 致谢

- 灵感来自 Cindori 的 [**Backdrop**](https://cindori.com/backdrop) — 那个精致的商业应用，本项目将其引擎开源重建。
- 菜单栏 + 窗口管理脚手架与 [**Whisky Claude**](https://github.com/ForceAI-KW/whisky-claude) 共享 — Claude Code 伴侣功能的兄弟项目。

## 许可证

MIT — 见 [LICENSE](./LICENSE)。

你可以自由再分发、fork、修改和基于此构建商业产品。只需保留版权声明。你播放的壁纸不受此许可证约束 — 它们有自己的许可（通常是原作者的 CC-BY 或类似条款）。请尊重来源站点的声明。

## Issues / 贡献

Issues 和 PR 欢迎：[github.com/ForceAI-KW/whisky-wallpaper](https://github.com/ForceAI-KW/whisky-wallpaper)。关于 Force AI 生态的更广泛问题（Whisky Claude 等），见 [forcemediakw.com](https://forcemediakw.com)。

---

## 更新日志

> 本项目更新日志，按时间倒序记录。

### 2026-07-27 — 初始 fork & 中文化

- Fork 自 `voidengineer-911/whisky-wallpaper`
- 原 `README.md` 重命名为 `README_EN.md`
- 新增中文 `README.md`（本文档）
- 后续中英双语切换、功能改进等更新记录于此
