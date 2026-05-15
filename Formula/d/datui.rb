class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.53.tar.gz"
  sha256 "af0c9348a753581c7f5fb6b0b60893fcb6d127ded2598a0d605ac480225e7148"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff48905c007715074038803cf2dee2ab79f9ac88855e8726e8e6005168a71296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5568064f2e7d2d9af8401527b1832bb61cfdf17b288b2240b32071a2ccd80a5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "474a431930a9224bda53cfe9fa74e09928e455eab650b2db1b8742cb779c9a99"
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
