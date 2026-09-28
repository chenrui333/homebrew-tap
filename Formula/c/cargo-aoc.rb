class CargoAoc < Formula
  desc "Simple CLI tool that aims to be a helper for Advent of Code"
  homepage "https://github.com/gobanos/cargo-aoc"
  url "https://github.com/gobanos/cargo-aoc/archive/refs/tags/0.3.7.tar.gz"
  sha256 "4e7695d8038d0e3c7f129943bc951adc41922e7ad6f7f9b6a9aaa3ce2d95e918"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/gobanos/cargo-aoc.git", branch: "v0.3"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c47e6da3f08966a016d3397667886820d3125b61932d18ea926402ea96a537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8515954ccd679c37a68b771c3ea181ad59eeafa669bc38d9e8718c4700a82a3b"
    sha256 cellar: :any_skip_relocation, ventura:       "926d22164c7adb1af94f0fbd47bdafae772686ec8785b9382d5bd993cb2afed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee4a0796a590431fa4371de9be9d9c01d5d15f5c92f5aa62e6e44ae867fb9b4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-aoc")
  end

  test do
    # Upstream hardcodes 0.3.0 in the CLI metadata.
    assert_match "cargo-aoc 0.3.0", shell_output("#{bin}/cargo-aoc --version")

    output = shell_output("#{bin}/cargo-aoc credentials")
    assert_match "Error: No session token available", output
  end
end
