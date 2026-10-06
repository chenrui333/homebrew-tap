class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "1537cee04ffa13a808e67c728f0c0b5beac3535da206c92d5773c95bb82d50d1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2074512ef4e653092fa0c19b44b1ddd0667f0199b510ab24f6cd22a7447b213b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77cdd61a5ddedd95aaef1272b65435c60103bec584b46415a9a70f636f3569c2"
    sha256 cellar: :any,                 arm64_linux:   "497819b26ffba6b1c4c661e4d32b876b27a4fcd744e32a75cc161329b3bdee19"
    sha256 cellar: :any,                 x86_64_linux:  "703c1533a052f9969eae114081c4b2d184b9d1be626d569552a06f5b3605fd41"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui config init")
    assert_match(/Wrote .*config\.toml/, output)
  end
end
