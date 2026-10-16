class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "b1ecf1a8aeedd377290414d0dcff00685d92a6bc9f8f56620b5c2bc168e88502"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d817a37ebad5562b085ca3ab979864cc8bf38d099ec9832b76ff1ff30840a097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44d3ca9ca33beaaae308caeb2129ddc3ec13af8a9f6bb25db2655d8e044b841e"
    sha256 cellar: :any,                 arm64_linux:   "cb4ddfdc29caf52566eae74e0f0b68943b0591bfae1593b6b3116b15e82dee39"
    sha256 cellar: :any,                 x86_64_linux:  "512879d367eeda41b942af344dea5ac0933a4c87bd08e8dbc0e9cae26a1f1c85"
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
