class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.31.tar.gz"
  sha256 "e8b37e9bc0ba24c2328f8243449f71bd0488c9c9e18b313055d9f0849a57248e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d361f66a1888f870a0b03943f50e328dd3b043291fb8b31506a4419591dd02d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d88a51270b8f98c71253196ec0928531213a2d974e67719bc3362266a1fe8a3"
    sha256 cellar: :any,                 arm64_linux:   "aaf082dc72312e155d78dce6fef99d671109088b15c0110f6c2aaee23ce35dfb"
    sha256 cellar: :any,                 x86_64_linux:  "bcfad2583cf2c8def1f2f3c3e3bc94a03dd320861d35ac5a59b4dab0f4d07fe3"
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
