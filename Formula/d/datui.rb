class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "67c302f38bc1549febc302318d42866305a4fd582e775ef9c19d99794f6dac80"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b1978a089ad0f98d70a298e126902dc853363298fc861d62ee9d84c7e02ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8e177bdb48cb55e02fd28a663355a5e5ecf89581ef9bd557f5c94b9c76ac6c"
    sha256 cellar: :any,                 arm64_linux:   "90d91309530f2e85291ecb807d87ab989e334748fe1562ed24d35845f2359749"
    sha256 cellar: :any,                 x86_64_linux:  "35ab56fae0b2d92088612a31a804d4a9324f645392c86840fc098fa5e1070af6"
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
