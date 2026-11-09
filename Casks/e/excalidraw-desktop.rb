cask "excalidraw-desktop" do
  url_end = on_system_conditional macos: "-arm64.dmg", linux: ".AppImage"

  version "1.0.11"
  sha256 arm:          "5578ffa374e7dfca1d5817b0e3a7dd1ded2fe2b523ca37b52b7f09f078569a07",
         x86_64_linux: "7f59e151c360fe1114b7a412d7d1082a85471eb5592f4e116f93bc4e898e8a6c"

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :monterey

    app "Excalidraw.app"

    uninstall quit: "app.excalidraw"

    zap trash: [
      "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/app.excalidraw.sfl*",
      "~/Library/Application Support/Excalidraw",
      "~/Library/Preferences/app.excalidraw.plist",
    ]
  end
  on_linux do
    depends_on arch: :x86_64

    app_image "Excalidraw-#{version}.AppImage", target: "Excalidraw.AppImage"

    zap trash: "~/.config/Excalidraw"
  end

  url "https://github.com/pgkt04/excalidraw-desktop/releases/download/v#{version}/Excalidraw-#{version}#{url_end}"
  name "Excalidraw Desktop"
  desc "Unofficial desktop client for Excalidraw"
  homepage "https://github.com/pgkt04/excalidraw-desktop"
end
