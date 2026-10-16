class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "b1ecf1a8aeedd377290414d0dcff00685d92a6bc9f8f56620b5c2bc168e88502"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1592ed9bf9a6e642351ea4249efd78803af79cdd87f5aa4491f34a3e156f35bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "872bd1cbd147fe71438ea59d001e3674642146c9bf5ba79c7e06d481f4fd05b4"
    sha256 cellar: :any,                 arm64_linux:   "8aeaac73000fc1ae65b398f7e29d3eb71a741f860665ca0e3466c7993cea2650"
    sha256 cellar: :any,                 x86_64_linux:  "b45f8d29b8aa0706d8fb4380e7dd0d3dc06a1d85aca1250b67e25201679e31cb"
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
