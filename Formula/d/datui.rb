class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "5e0706da6cfcff04822cad1b8b6335ad8105975be9246565695763d76f4633f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c7fd262b13d0a41d9e091442adf3f5fa9315d1ec83aa42be13a2d3afdd72986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8df9f5bc1ff5b521ef457e2b42b24d8b4685f3a763698482886c89c7dd49fa11"
    sha256 cellar: :any,                 arm64_linux:   "616bfd9dc860474bd0bfdc9c41085976a01b3915a81d4a21e1537dbd799d0c8d"
    sha256 cellar: :any,                 x86_64_linux:  "c6d0da1c831696b7d8376f7030c3ba35efb50c0db1485e545b34e0b7768949de"
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
