class Holo < Formula
  desc "Terminal based profiler and app inspector for Android"
  homepage "https://github.com/measure-sh/holo"
  url "https://github.com/measure-sh/holo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fa6cdd87cad8d7336f991fb4d8d8f79164a04e1aaf47268c656e22f588cc113d"
  license "MIT"
  head "https://github.com/measure-sh/holo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "045ddfc00d7b3e14972b585ceff7b565a51496fd3d0be17961ceb2ca55c5b123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ecb1bda582d2df6fc249d49f3966b9ae2eb27a6a81370a25e572283bfbefa97"
    sha256 cellar: :any,                 arm64_linux:   "3d692daa0e815e60eef549c246033b1b824f298d5dcb490af0e50bfe3f5f17da"
    sha256 cellar: :any,                 x86_64_linux:  "5537b9db0187d71357a5641accb7035f54379f5eb586237faff1afc7548334d8"
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
    assert_path_exists bin/"holo"
  end
end
