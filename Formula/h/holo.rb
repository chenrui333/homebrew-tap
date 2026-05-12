class Holo < Formula
  desc "Terminal based profiler and app inspector for Android"
  homepage "https://github.com/measure-sh/holo"
  url "https://github.com/measure-sh/holo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9abcff896d59012ab74f91df6bf0a2ecc6f33d596d65970a4e1c49a451d595c0"
  license "MIT"
  head "https://github.com/measure-sh/holo.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "holo", shell_output("#{bin}/holo --help 2>&1")
  end
end
