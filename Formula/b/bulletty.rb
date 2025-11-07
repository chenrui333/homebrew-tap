class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "855aa55629ca0846b1b50a87f2c18c2b7f76d8aa0fbd276187b70a5cb3bc34da"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8899e59ca4429b57b0555b70876a07575d4662095c1c9664126d63668a50fb38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e95deabacbfacbf55c1736d608f1d386aff5b1cf890d71033d3c3338060e6a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eadd372f22144892cd42108eb431bda1714987ff4175686db1e33dd97811f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9afa8979b64f1429be521ccbf6fc00c1782ca9364d81a05c6aa01e76bc189756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dec25b6ae20f065ebb9b1664e080f1d24689bb81e2922382fa6d48e9200d1b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
