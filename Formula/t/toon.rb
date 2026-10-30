class Toon < Formula
  desc "Token-Oriented Object Notation encoder and decoder written in Rust"
  homepage "https://github.com/toon-format/toon-rust"
  url "https://github.com/toon-format/toon-rust/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5184701e468819a90e9e23503abc9ed71307c8ab27e578621a956a2174dd1b8a"
  license "MIT"
  head "https://github.com/toon-format/toon-rust.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a1d62c0cc5d5775fdd98c40644845fead0029c2a2b4ca7378f633cccc27e4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bbd0803983b6ed22e0927d7653cc34b1fe5142723160068c182b6c4e9915213"
    sha256 cellar: :any,                 arm64_linux:   "566891f54b9519dc699f0f8e10b4ed70d27604c8658c679e08825fdecef0931a"
    sha256 cellar: :any,                 x86_64_linux:  "1d6a88e553a3b47ee487a93bce4cfed67764fcc7536c9eea2c0cd94964535e71"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toon --version")

    input = { "name" => "Homebrew", "active" => true }
    (testpath/"input.json").write input.to_json
    system bin/"toon", "input.json", "--encode", "--output", "output.toon"
    assert_equal "name: Homebrew\nactive: true", (testpath/"output.toon").read
    assert_equal input, JSON.parse(shell_output("#{bin}/toon output.toon --decode"))
  end
end
