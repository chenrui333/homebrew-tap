cask "focus-editor" do
  os macos: "macOS.dmg", linux: "linux"

  version "0.3.8"
  sha256 arm:          "56883831e607892c050325e17b8b354fda69a538111bc2b84f7ad3b8bccb3db0",
         intel:        "56883831e607892c050325e17b8b354fda69a538111bc2b84f7ad3b8bccb3db0",
         x86_64_linux: "cbb30eb2cd73e8bd7ace56e0f3ff4cb1ae93fa24aab9378610f221416112e0ec"

  on_macos do
    app "Focus.app"

    zap trash: "~/Library/Application Support/dev.focus-editor"

    caveats do
      requires_rosetta
    end
  end
  on_linux do
    depends_on arch: :x86_64

    # Upstream's generated desktop entry hardcodes `Exec=focus-linux`, so keep that name on the PATH.
    binary "focus-linux"

    zap trash: [
      "~/.config/focus-editor",
      "~/.local/share/applications/dev.focus-editor.focus.desktop",
      "~/.local/share/focus-editor",
    ]
  end

  url "https://github.com/focus-editor/focus/releases/download/#{version}/focus-#{os}"
  name "Focus"
  desc "Simple and fast text editor"
  homepage "https://focus-editor.dev/"
end
