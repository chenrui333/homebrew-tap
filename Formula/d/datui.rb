class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.54.tar.gz"
  sha256 "14a4819106ecff0b43c0ac3c61dadf84088c9725db2bede372672913c667d6c6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "687b1f76219d2079a2cfcaabd047ca9ea6cdbf79cf8babd946821a267ba331c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d244f3af482141430ca93227aa311f82d12b94022f58b8f98251fbabd5f96989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7e45df5a54d62c3a4c907848b4d2d2ef472d7364bb354217e4112aa5e5def2e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui --generate-config")
    assert_match "Configuration file written to:", output
  end
end
