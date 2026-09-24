class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "82e709e755511b1c97330c77cbf6cb337914ce3c8c76a5a939cc0e2881082b79"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ad253254273cc518023173336b3fcc38ad0f6df3b459895d170ee2ea6d5350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea4f566fdea0cd3229a50418ce5ff407ee7edfe43887ecea8286b239d0294a8"
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
