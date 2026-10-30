class Toon < Formula
  desc "Token-Oriented Object Notation encoder and decoder written in Rust"
  homepage "https://github.com/toon-format/toon-rust"
  url "https://github.com/toon-format/toon-rust/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5184701e468819a90e9e23503abc9ed71307c8ab27e578621a956a2174dd1b8a"
  license "MIT"
  head "https://github.com/toon-format/toon-rust.git", branch: "main"

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
