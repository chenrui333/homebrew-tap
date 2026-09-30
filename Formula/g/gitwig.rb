class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "3f8f10227efcf56da6ef430e786199a917eb12ec9914e86ea29a767e7d00b9df"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01020955990afccd521b7e785bc817f80c0097d9a05c6372c6e53dd64b503921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e189d259553f37a187b182ac72ee34737aa3aa4094a4ef151439694d6d34f9"
    sha256 cellar: :any,                 arm64_linux:   "990b45a8444b4c4534b9efc22d6200aa808211ddaf5398771b415c12d0663d2f"
    sha256 cellar: :any,                 x86_64_linux:  "c22436aae1dd3ccfe3237e7ea43527c2454d7c4d6574a296908d9db1990f061b"
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
