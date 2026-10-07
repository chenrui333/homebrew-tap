class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "d13bd02c0f960551eabf7ae6fdb2edb33318d6ce0fa32006183c3424aa598eb0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dedbccd4e2cc159a0990c65aa2bf754fcd5f56aad2eaace22e75230a43a12df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ac7db8138cf02a42ba75d231c1258f120ea0a35a76b1cc407a8e69dc9f22225"
    sha256 cellar: :any,                 arm64_linux:   "2d3f98055ea5668ff7028499719f2025a8f1b938bea0ca0d63b07127da3af686"
    sha256 cellar: :any,                 x86_64_linux:  "c41f8c39aca9f61c8cfd7a35962575fec1b1aadf047ec420233179cab23c4314"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui config init")
    assert_match(/Wrote .*config\.toml/, output)
  end
end
