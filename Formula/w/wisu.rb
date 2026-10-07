class Wisu < Formula
  desc "Blazingly fast, minimalist directory tree viewer"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "0331ebc1663c3fcc4c58992692b6dc952d8733d1d77efac71250bb2689925edd"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6b5de36886d13e62c3479ad10614bf9f7afe1eac0e7b89f59817631c2cd6640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca1d6aff37ac4e9afe2e8a7af00ca9f873ce95ab58da6b8e791b70a193d40c4"
    sha256 cellar: :any,                 arm64_linux:   "74adbb00bd1a9058d1b62594e52401ee372bdc082bf9381cfa82cfb2577d7313"
    sha256 cellar: :any,                 x86_64_linux:  "c27c6a96cd1638fa18a60714da1df1e5d777f160fd3a7369a0487696e9cd4763"
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
    assert_match(/^wisu \d+\.\d+\.\d+$/, shell_output("#{bin}/wisu --version"))

    (testpath/"a.txt").write("a\n")
    output = shell_output("#{bin}/wisu #{testpath}")
    assert_match "a.txt", output
  end
end
