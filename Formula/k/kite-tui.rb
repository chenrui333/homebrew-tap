class KiteTui < Formula
  desc "Terminal reader for Kagi News"
  homepage "https://github.com/KernelFreeze/kite-tui"
  url "https://github.com/KernelFreeze/kite-tui/archive/refs/tags/0.1.1.tar.gz"
  sha256 "0a1946783888fb51b6e6f8306e5953b344ad7d96a8eae58f0c101f1a4e3e4cd1"
  license "MIT"
  head "https://github.com/KernelFreeze/kite-tui.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "kite #{version}", shell_output("#{bin}/kite-tui --version")
    assert_match "A terminal viewer for Kagi News", shell_output("#{bin}/kite-tui --help")
  end
end
