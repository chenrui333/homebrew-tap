class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.28.tar.gz"
  sha256 "80876fb4a74ca9ec9808af99deac5201ce560e3674393a89b109dccb2bb9b45b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85291e89095b214a5d7950b5b7fcb721e7fe4cdf69cfc36c797f6f28e33607e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16e957b7580c657f4cfa8526bd8867fa3696616e83d9c1c823d8bc5032942b68"
    sha256 cellar: :any,                 arm64_linux:   "030422a29701e0d65ac551b27ade57244be2c1f85aaaaf123e7285cfe521c3e6"
    sha256 cellar: :any,                 x86_64_linux:  "8458eb6236e2dc31e59313e0212cf02888e94c586befe4f616abbca9565f94b7"
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
    ENV["HCOM_DIR"] = testpath
    # A fresh update cache prevents the detached online version check.
    update_cache = testpath/".tmp/flags/update_check"
    update_cache.dirname.mkpath
    update_cache.write("")

    assert_match version.to_s, shell_output("#{bin}/hcom --version")
    assert_match "Terminal set to: tmux", shell_output("#{bin}/hcom config terminal tmux")
    assert_match "Terminal: tmux", shell_output("#{bin}/hcom config terminal")
  end
end
