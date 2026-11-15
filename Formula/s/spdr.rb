class Spdr < Formula
  desc "Read-only DDR5 SPD decoder and semantic linter in Rust"
  homepage "https://github.com/The-Open-Memory-Initiative-OMI/spdr"
  url "https://github.com/The-Open-Memory-Initiative-OMI/spdr/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "fbe7c4a9de2aa90df21e193aa94774d488dd5ffb35d1db209c22636850e2589a"
  license "Apache-2.0"
  head "https://github.com/The-Open-Memory-Initiative-OMI/spdr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef0bedee8607d71f67159750296b86f0b697d6c3f154542cb64bb744fbb5dde6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e8fe14cd00dc11a18d1e205de361ce127ab2b1e932ce38b32e87f0429eea0e3"
    sha256 cellar: :any,                 arm64_linux:   "754d51f4c778f9e47d1906d0df353d1b8c30a68e90ce725bb9379066fd53bd11"
    sha256 cellar: :any,                 x86_64_linux:  "7e0e2a0e8562e3495109bd3d9e4967cba762f99de07e6e73cc156532b0fbe736"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "spdr-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spdr --version")
    output = shell_output("#{bin}/spdr not-a-real-command 2>&1", 2)
    assert_match "unrecognized subcommand", output
  end
end
