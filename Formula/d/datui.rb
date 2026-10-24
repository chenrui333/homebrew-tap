class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "e6fea78902f2c5e22057cda1250d26afd3f3553b6bee89b2dfdad03f4cfcf18f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaf32611e7438af87f35cb67700f8ac46ccff15fd8a10dc58b55809f579bcff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbba615005b6f853d132e3ee4620d7cb24eafe9a4b9ffcb039b53d5b7e681055"
    sha256 cellar: :any,                 arm64_linux:   "79da1969d84d0217e806506bb31fd38b96017150759ae274ab11d1300f081832"
    sha256 cellar: :any,                 x86_64_linux:  "248c41b833260ed7be836d1f7ceb0c435c39e370ecfee8e1b2a01b055ed6c908"
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
