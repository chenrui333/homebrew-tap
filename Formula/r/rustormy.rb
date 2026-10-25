class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "5b0f455259d62f824f4f0b07de4fd524e3f972a63fee383dcd91adb0c59a2b67"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e256e9cb44f3e90fecf9da75fcfe34bdf3d9c7547652e33bce6ef4dbab3b9edb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e99903715f1cc365a74c4b57b7f09d1a98c4aeca005558938a362625b923cc0"
    sha256 cellar: :any,                 arm64_linux:   "9acdd0cfc55bf797024792bd2f15267c3a1de58c62b83a212f63b639bd002217"
    sha256 cellar: :any,                 x86_64_linux:  "661ecf45abc8f12048f06e30a559c7f976650207427c2073d20fe9811b91732c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustormy --version")
    assert_match "Cache cleared successfully.", shell_output("#{bin}/rustormy --clear-cache")
  end
end
