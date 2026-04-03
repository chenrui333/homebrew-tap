class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.52.tar.gz"
  sha256 "e5e7f4c1e5a4a81023707738ef601ddaa58c54d39337eebcf9963010b5e262ad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "297919b95f71c02d3f2ad5b90460fd9866037d6f24b1145f90d2a3c04743cb24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "051f3674420a8a38115398114b3f50b71e6a69a090ea968763e4cd71b8c5dcc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e80698b4c2848f1d84c558e33a654bfb84fed723c1136161fc8327781e04dae"
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
