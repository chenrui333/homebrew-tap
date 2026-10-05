class Mcdu < Formula
  desc "Modern disk usage analyzer and developer cleanup tool"
  homepage "https://github.com/mikalv/mcdu"
  url "https://github.com/mikalv/mcdu/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6a6a4759a81754962d8958de64fe51eff5355188dac5b207af019cd68dcc30ca"
  license "MIT"
  head "https://github.com/mikalv/mcdu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13edbdbb74b3bda00f69364656887288515d2f702bcade7d80c73bd707ffa986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02af55b71442d22891a52cb7f31c9272707113bf1e4cc5914b50bfb9e52624cc"
    sha256 cellar: :any,                 arm64_linux:   "c3fc2d51343db45a3ab75e98709d4ae7829929324d349f298d3fbc9f8b528464"
    sha256 cellar: :any,                 x86_64_linux:  "7d3161d34c8d434f2700f6c7ea272bfab8e39ed629870bdafbdb3910931362a3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mcdu")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcdu --version")
    output = shell_output("#{bin}/mcdu #{testpath}/missing 2>&1", 1)
    assert_match "Path does not exist", output
  end
end
