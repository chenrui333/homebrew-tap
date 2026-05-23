class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "acc6199bcce8916295f95b491548e18f4e5c0227afb22506529819dea9cd2acd"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33e363d8885817b10194f76318c6442abdb64337efc280c74ec58f41476a97d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92f619e13a0ef42ce2863ae3ec59819137e761763a401214a124fb351c2896c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94205de71454a54121577f78ed4055d98e687ec49c2e56648a1c03235b7b1a97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b615536f251e4161cd9777247bc40bb84830e6950812f4602981cdc8c2d27154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dc9b0ce4f7cd7809ff8a3d5d487f9bbe87b3058b121d87ac8efcbcddda57843"
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
