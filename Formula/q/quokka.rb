class Quokka < Formula
  desc "Inspect and clean iOS and Android devices over USB"
  homepage "https://github.com/dutradotdev/quokka"
  url "https://github.com/dutradotdev/quokka/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "ea0356c1b3b85dceddec50edfde30cfe7f25fa67be2a3ecb51ed092fad770e79"
  license "MIT"
  head "https://github.com/dutradotdev/quokka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d08a91af04d6ddf6b457f0103ad93ccdcc4163feba4fe9ef615b2defa1b7768"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde10490a795db74ee45baeba8816028a74fc7ca52cbd39632a6271143a18e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e59d4e6e7730749011fde6251caafbb7cccd1275a40a98ad6fa0eb972b0db1ef"
    sha256 cellar: :any,                 arm64_linux:   "86e9cafe8cab58dc816ef5db2ba17b339de67b2c20907dec7cd4cf5b9388f239"
    sha256 cellar: :any,                 x86_64_linux:  "7c4a9b8a07b87a0bc76e5d9ad78736efeaf1dbb7392d9c47a7f0daefbcd93f39"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/quokka-cli")
  end

  test do
    assert_match "quokka #{version}", shell_output("#{bin}/quokka --version")
    assert_match "short alias", shell_output("#{bin}/qk --help")
  end
end
