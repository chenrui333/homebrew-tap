cask "wechat@3.8" do
  version "3.8.8"
  sha256 "7febd3b81d807be0beeb8ecb94cefb7240ecd38621a90e7277d1f275d4ec8780"

  url "https://mksoftcdn.yesky.com/692926fe/ff100b986d8e61cf271ac95e5c3cacbe/uploadsoft/WeChatMac-3.8.8.dmg"
  name "WeChat for Mac"
  name "微信 Mac 版"
  desc "Free messaging and calling application"
  homepage "https://mac.weixin.qq.com/"

  # # This appcast is slower to update than the submissions we get. See:
  # #   https://github.com/Homebrew/homebrew-cask/pull/90907#issuecomment-710107547
  # livecheck do
  #   url "https://dldir1.qq.com/weixin/mac/mac-release.xml"
  #   strategy :sparkle, &:short_version
  # end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "WeChat.app"

  uninstall quit: "com.tencent.xinWeChat"

  zap trash: [
    "~/Library/Application Scripts/$(TeamIdentifierPrefix)com.tencent.xinWeChat",
    "~/Library/Application Scripts/$(TeamIdentifierPrefix)com.tencent.xinWeChat.IPCHelper",
    "~/Library/Application Scripts/com.tencent.xinWeChat",
    "~/Library/Application Scripts/com.tencent.xinWeChat.MiniProgram",
    "~/Library/Application Scripts/com.tencent.xinWeChat.WeChatMacShare",
    "~/Library/Caches/com.tencent.xinWeChat",
    "~/Library/Containers/$(TeamIdentifierPrefix)com.tencent.xinWeChat.IPCHelper",
    "~/Library/Containers/com.tencent.xinWeChat",
    "~/Library/Containers/com.tencent.xinWeChat.MiniProgram",
    "~/Library/Containers/com.tencent.xinWeChat.WeChatMacShare",
    "~/Library/Cookies/com.tencent.xinWeChat.binarycookies",
    "~/Library/Group Containers/$(TeamIdentifierPrefix)com.tencent.xinWeChat",
    "~/Library/Preferences/com.tencent.xinWeChat.plist",
    "~/Library/Saved Application State/com.tencent.xinWeChat.savedState",
  ]
end
