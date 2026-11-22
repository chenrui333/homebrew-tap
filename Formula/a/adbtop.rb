class Adbtop < Formula
  desc "Monitor Android app performance over ADB from the terminal"
  homepage "https://github.com/aabolfazl/adbtop"
  url "https://github.com/aabolfazl/adbtop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee7a9108bc1aa15bfefffde375f0d02998169d1231fc6d31fc4935095c59d74d"
  license "MIT"
  head "https://github.com/aabolfazl/adbtop.git", branch: "master"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Install Android SDK Platform-Tools and put adb on your PATH.
      For optional network capture, use `adbtop agent install --apk FILE`
      with the matching capture agent APK. The APK is not bundled.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbtop --version")
    assert_match "Tokyo Night", shell_output("#{bin}/adbtop themes")
  end
end
