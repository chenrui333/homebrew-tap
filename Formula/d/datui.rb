class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.50.tar.gz"
  sha256 "ee5a5fb120b4da52227e62772b4f893a342449420f8f30899969bdb913bd4eee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f95e744d35717eb57183e1f2619f5f92f4bb8229d6ac7a9f52d826c7d5ca9aaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "271809a4c0143cd5214e0244f0b3f8150bd714e5eef4e207978aeb655a0141d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75e5d7634f4a66954f39e6de08aec34f5a4e264ad9d8cbebd61c43c3d7cfb071"
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
