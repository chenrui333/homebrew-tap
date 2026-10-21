class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.31.tar.gz"
  sha256 "e8b37e9bc0ba24c2328f8243449f71bd0488c9c9e18b313055d9f0849a57248e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b0944c4412a567162560e4f8fe4431e787fdbfb57e8d8cb28445257848200cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0561a9dbfd4a2f0b64b9d43d85395f29306e654aa36020008a6f641976606b0f"
    sha256 cellar: :any,                 arm64_linux:   "6f142075d8849548f6cb397d302acb2ea6d73ff53ef0158352e91cd6bbe0376d"
    sha256 cellar: :any,                 x86_64_linux:  "dac5e638860dcac19d83a5a5346b65c979d9c4039a6ba9a0f2b871f0bc7206d9"
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
