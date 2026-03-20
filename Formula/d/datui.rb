class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.51.tar.gz"
  sha256 "f61fde3d7e33b95054de9058c1b6505117953654f9db022541314d89a88b65c6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe942e191a2def3eb1aec7523e522ab2b33a4bfe9465f3832a2f1209674fb92a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3d624fb4bffb39478f008541b1d5bea57f6412e6b802440989989db9d014be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2010a3ff5567e8a6827534a3c3ba93788f74f536df0a8a107b3a808e61cff34"
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
