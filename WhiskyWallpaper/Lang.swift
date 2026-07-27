import Foundation

/// 语言管理 + 中英双语字符串字典。
/// 不使用 NSLocalizedString — 项目体量小，直接字典查表。
enum Lang {
    enum Language: Int {
        case chinese = 0
        case english = 1

        static var systemDefault: Language {
            let preferred = Locale.preferredLanguages.first ?? "en"
            return preferred.hasPrefix("zh") ? .chinese : .english
        }
    }

    private static let kAppLanguage = "appLanguage"

    /// 当前语言。首次启动跟随系统语言，用户切换后持久化。
    static var current: Language {
        get {
            let saved = UserDefaults.standard.integer(forKey: kAppLanguage)
            return saved == 0 && !UserDefaults.standard.bool(forKey: "appLanguageSet")
                ? .systemDefault
                : Language(rawValue: saved) ?? .systemDefault
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: kAppLanguage)
            UserDefaults.standard.set(true, forKey: "appLanguageSet")
        }
    }

    // MARK: - 字符串查表

    /// 查表返回当前语言对应的字符串。
    /// 带 {X} 占位符的字符串，调用方用 replacingOccurrences 替换。
    static func t(_ key: String) -> String {
        let zh = chineseStrings[key] ?? key
        let en = englishStrings[key] ?? key
        return current == .chinese ? zh : en
    }

    // MARK: - 中文

    private static let chineseStrings: [String: String] = [
        "now_playing":        "正在播放：",
        "no_wallpaper":       "未选择壁纸",
        "rotating_now":       "正在切换…",
        "next_change":        "{X} 分钟后切换",
        "pick_file":          "选择壁纸文件…",
        "pick_folder":        "选择壁纸文件夹…",
        "rotation":           "轮播",
        "rotation_off":       "关闭",
        "rotation_every":     "每 {X} 分钟",
        "switch_random":      "立即随机切换",
        "playlist":           "播放列表（{X} 个视频）",
        "no_videos":          "文件夹中无视频",
        "resume":             "继续",
        "pause":              "暂停",
        "reload":             "重新加载壁纸",
        "lock_sync_on":       "锁屏同步：开",
        "lock_sync_off":      "锁屏同步：关",
        "lock_sync_tooltip":  "开启后，将当前视频注册为系统 aerial 并设静态帧为锁屏壁纸",
        "reveal_finder":      "在 Finder 中显示",
        "quit":               "退出 Whisky Wallpaper",
        "set_as_wallpaper":   "设为壁纸",
        "pick_video_message": "选择视频文件 — 支持 .mov、.mp4 等 QuickTime 格式",
        "use_as_folder":      "设为壁纸文件夹",
        "pick_folder_message":"选择文件夹 — Whisky Wallpaper 将轮播其中的 .mp4 / .mov 文件",
        "language":           "语言",
        "lang_chinese":       "中文",
        "lang_english":       "English",
        "accessibility":      "Whisky Wallpaper",
    ]

    // MARK: - 英文

    private static let englishStrings: [String: String] = [
        "now_playing":        "Now playing: ",
        "no_wallpaper":       "No wallpaper selected",
        "rotating_now":       "Rotating now…",
        "next_change":        "Next change in {X}m",
        "pick_file":          "Pick wallpaper file…",
        "pick_folder":        "Pick wallpaper folder…",
        "rotation":           "Rotation",
        "rotation_off":       "Off",
        "rotation_every":     "Every {X} minutes",
        "switch_random":      "Switch to random now",
        "playlist":           "Playlist ({X} videos)",
        "no_videos":          "No videos in folder",
        "resume":             "Resume",
        "pause":              "Pause",
        "reload":             "Reload wallpaper",
        "lock_sync_on":       "Lock-screen sync: On",
        "lock_sync_off":      "Lock-screen sync: Off",
        "lock_sync_tooltip":  "When on, Whisky registers the current video as an aerial in System Settings → Wallpaper and sets a still frame of it as the lock-screen image.",
        "reveal_finder":      "Reveal in Finder",
        "quit":               "Quit Whisky Wallpaper",
        "set_as_wallpaper":   "Set as wallpaper",
        "pick_video_message": "Pick a video file — .mov, .mp4, or any QuickTime-playable format.",
        "use_as_folder":      "Use as wallpaper folder",
        "pick_folder_message":"Pick a folder — Whisky Wallpaper will rotate through its .mp4 / .mov files.",
        "language":           "Language",
        "lang_chinese":       "中文",
        "lang_english":       "English",
        "accessibility":      "Whisky Wallpaper",
    ]
}
