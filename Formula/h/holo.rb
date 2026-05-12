class Holo < Formula
  desc "Terminal based profiler and app inspector for Android"
  homepage "https://github.com/measure-sh/holo"
  url "https://github.com/measure-sh/holo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "fa6cdd87cad8d7336f991fb4d8d8f79164a04e1aaf47268c656e22f588cc113d"
  license "MIT"
  head "https://github.com/measure-sh/holo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbea51ddae81e797c5bbe6faa40af08081ea6a2a25d6b665e8c8534fc484a801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6155fcf3ce91f71267e25c84666e04ca9a82ada0a25a8b9043fdd22b42ee7ed3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65cf1cc8f25faa0899ebf1bca72970f688c3120d83813a080d591a29d186f23c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc9cbe30aa781f2a247676591238340e374b0d381953b4d6104b929cd44d5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6377fcdc05304878f9b84be05cf92c942785a68b41ca87d02f09e61e79e896"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_path_exists bin/"holo"
  end
end
