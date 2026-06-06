class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.55.tar.gz"
  sha256 "9c09388ee3ee810f1ddbf07dee88dad31b555e2aabd24d19ea7fea124716753b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbbf165273b3a51a2ae2b9553c4077a2301cec790088581c926f35c1a7341440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ad95409932cd01f778ffd014b331a365c60e257d2522fa89873f01ac8f319d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ee9ed4c637698c4db8e45c83c25bde9c4f7d141de846918d17d8291c5bf00b"
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
