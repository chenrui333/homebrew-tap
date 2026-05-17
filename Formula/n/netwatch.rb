class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.15.12.tar.gz"
  sha256 "ebdb173837b5f86ba1a42db65ccee87f6c86f85bac37f079c62ebd49a7982f0b"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95a399f5c1f75853f3538ec4c139596424495a0b9c53e65cbc1644b4e4ac9f4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed1dfd1bfdfddec7996fae8181c49a6f8e9b07e3d97cf3916f897fd2fe48106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb74b1b92cf1f1e557f7361163a36272673e879fe162227cbf28fb9cf78ee1d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c378a20dbb28d6562022e7ef8c31302fa307559c7039add77a15c2162462252d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f282f7ff5f04a2d6c13f7fee80ae65824d6510a89355a1e6e3757b485d61863"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
