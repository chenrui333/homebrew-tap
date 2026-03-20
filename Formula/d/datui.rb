class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.51.tar.gz"
  sha256 "f61fde3d7e33b95054de9058c1b6505117953654f9db022541314d89a88b65c6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df65c713824c2b15a516955a72aead0e4cdd1f6c69f1a99f5b39e4dfc63230a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8abea1500725fec7413a1206710f179719d8f7e23c9c3d77350b84b266f2081b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a8d98c57b343d68376c59562162df761daf8813809c3868030ac81e9ce8b1a"
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
