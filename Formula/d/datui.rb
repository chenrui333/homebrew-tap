class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.2.49.tar.gz"
  sha256 "461640173fccaedeb3a140ea15f3beb739b394271a2514bd9aa789a04a44f8c4"
  license "MIT"
  revision 1

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui --generate-config")
    assert_match "Configuration file written to:", output
  end
end
