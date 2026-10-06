class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "47efbdc3eecbd5388a59e6a7e36ab925a95fcf2851241523d20d43f8c461eae8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ad253254273cc518023173336b3fcc38ad0f6df3b459895d170ee2ea6d5350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea4f566fdea0cd3229a50418ce5ff407ee7edfe43887ecea8286b239d0294a8"
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
