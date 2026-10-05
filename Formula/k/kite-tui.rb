class KiteTui < Formula
  desc "Terminal reader for Kagi News"
  homepage "https://github.com/KernelFreeze/kite-tui"
  url "https://github.com/KernelFreeze/kite-tui/archive/refs/tags/0.1.1.tar.gz"
  sha256 "0a1946783888fb51b6e6f8306e5953b344ad7d96a8eae58f0c101f1a4e3e4cd1"
  license "MIT"
  head "https://github.com/KernelFreeze/kite-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4c092c213197da8aae8c14e9ce49a86647d42a7c7b7f396c970154601194519"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da46fbdaacba12158d58c03a044461cdb02260b8868e93cbcd869e6445004099"
    sha256 cellar: :any,                 arm64_linux:   "e332725b0b68955a8516dbffa407dc3bdcf20e9af1fc6cbbe08607284d2237e3"
    sha256 cellar: :any,                 x86_64_linux:  "c6448b1044a4a10be044bc83d148522b90ec361b1c18dcd812be68bc46ce9eea"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "kite #{version}", shell_output("#{bin}/kite-tui --version")
    output = shell_output("#{bin}/kite-tui --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
