class Holo < Formula
  desc "Terminal based profiler and app inspector for Android"
  homepage "https://github.com/measure-sh/holo"
  url "https://github.com/measure-sh/holo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fa6cdd87cad8d7336f991fb4d8d8f79164a04e1aaf47268c656e22f588cc113d"
  license "MIT"
  head "https://github.com/measure-sh/holo.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_path_exists bin/"holo"
  end
end
