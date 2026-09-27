class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "fc1fcf5250543337d9c1649ebe6f8fbcc0dfd2ffc6fd4c23e36097c87fe7ea4e"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dc824c6f932a5307d1979a9f07d1db0f512c3f3ff3dd1d36a8271c3f42abb67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45ebe0b4404517c1eba3b55d416f8b3cdc1262821d034c15ed26aabcf271970"
    sha256 cellar: :any,                 arm64_linux:   "3981b2b52e014b0449aa033f3305e2d678e2f991f86b638e7eda8b2b8b7fe201"
    sha256 cellar: :any,                 x86_64_linux:  "996036a251e860d56acd7f838c300c4d2aa236274fb23de625fb3c9507746022"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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
