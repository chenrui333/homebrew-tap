class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "855e4ffea1acc937a924d6db6df2ac48198fd7128ee05508477662243c33c866"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d264c9e707b837b067c24a1e9392d16c9617c9717abc5ecd34e120301978207c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47aee5ae41e9fd11f066b004fc013f5718dfcac8625b8598ab814fe8118c007c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccb06e2342c56e64bcbfbbd22236159ceaa08003975e16fc9d29840b5521f02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c1f4b14b70c1fce2dc2aac88b22b0e5fdcb2dffdd7e4d91c9ca2d3e770cbe4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33556cd204ed3771ccc5cb2ef6e6788f4223041becd1ee369a78ab5d6170c33a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "eb9122ffff587d1cb9e56682d68a637e8efaa6c0cd3db5d90da542d1ce0bd2c2", output
  end
end
