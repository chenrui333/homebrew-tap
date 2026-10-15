class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.30.tar.gz"
  sha256 "46b3210a516dbad0ca6e522b4b7c98d9909c8395e38cad30022a10e7514ea600"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b81d8332ccaff874892a817f42047f627db2c7905cb3d06d898298669eccba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b796b6f9027c22477796e03504a41ab979ab1c9e660ed4c697229fca2e161a16"
    sha256 cellar: :any,                 arm64_linux:   "9710bff2808d0f0d93ea7ef6d3798e26275e24e228ea8459ef84af215a3a6691"
    sha256 cellar: :any,                 x86_64_linux:  "59513ac61b97a42385439fbf3c83c4df9a237e8bb4dd454d13c59fcda03e75fd"
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
