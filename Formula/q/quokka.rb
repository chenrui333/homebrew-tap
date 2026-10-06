class Quokka < Formula
  desc "Inspect and clean iOS and Android devices over USB"
  homepage "https://github.com/dutradotdev/quokka"
  url "https://github.com/dutradotdev/quokka/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "ea0356c1b3b85dceddec50edfde30cfe7f25fa67be2a3ecb51ed092fad770e79"
  license "MIT"
  head "https://github.com/dutradotdev/quokka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "328c9f2dddfbf2ef61ee51f5cac51e235d3c83fe4a869b7f6e00ecf2dfcb6997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbcd9a5d2e0da15cfad45b1ab95ad46ea5bce328657542f4d5c78673abe858a0"
    sha256 cellar: :any,                 arm64_linux:   "6850b808a7bee006d4b000d1c741d6b9cc4e973c20a2adb79d83fe17b2091535"
    sha256 cellar: :any,                 x86_64_linux:  "952d244ba4c83be6ca876bbe374bcba94af88203bd74dda5d35991c9115e1dab"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/quokka-cli")
  end

  test do
    assert_match "quokka #{version}", shell_output("#{bin}/quokka --version")
    assert_match "quokka #{version}", shell_output("#{bin}/qk --version")
  end
end
