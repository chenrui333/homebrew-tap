class Sigye < Formula
  desc "Feature-rich terminal clock with ASCII art fonts"
  homepage "https://github.com/am2rican5/sigye"
  url "https://github.com/am2rican5/sigye/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8a5b440ee53d574af35eed8c85455ab5bd413052ee6fb8534d2e954b6530deac"
  license "MIT"
  head "https://github.com/am2rican5/sigye.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b34160a75617185e932632a19f5b9e6167fa25de6dba5a57fbc9f1cc151ed25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f75e454e4bbeb8ecb98d3473d81ef494760a441ffdae8b2b92bd6124be929f5"
    sha256 cellar: :any,                 arm64_linux:   "40c10fb1e7ceb69d121f2258d10ac51dccb4c2b4b250af303721105b90ea10c7"
    sha256 cellar: :any,                 x86_64_linux:  "2d6e28ad167557e844c3fe020bf1aba380afa0779224e24f8ac6057cc615b862"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--manifest-path", buildpath/"Cargo.toml"
  end

  def install
    ENV["CARGO_NET_OFFLINE"] = "true"
    system "cargo", "install", *std_cargo_args(path: "crates/sigye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigye --version")
    output = shell_output("#{bin}/sigye --once --format unix")
    assert_match(/\A\d+\n\z/, output)
  end
end
