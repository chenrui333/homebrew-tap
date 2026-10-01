class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "11282639bbafdb1dbb0f2e9498fb65e594b2d1d09840eb348bb874d7e192cb16"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8a6ef054b703dd0fb06586903547d9eabf40dd5f524338d29e1b3cfd9da51d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f939d09164da60750702c9b61a7c75fad6b4c569acf2c0ecb5e7ab05690326"
    sha256 cellar: :any,                 arm64_linux:   "2ff659cba8164272d0d0f9bc2c0e5d16bba7f0a6b5b7662ccc66555d241f6227"
    sha256 cellar: :any,                 x86_64_linux:  "679040a615990453e3fe4cbc43cd244a7321f6189e3d778c8c300c77928c3b21"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitwig --version")
    assert_match version.to_s, shell_output("#{bin}/gtg --version")
    with_env(PATH: testpath.to_s) do
      output = shell_output("#{bin}/gitwig 2>&1", 1)
      assert_match "'git' command-line tool not found on PATH", output
    end
  end
end
