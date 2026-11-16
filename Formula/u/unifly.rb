class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e1ccaaace6c5cb64b88d9f70264655b1ed197f6fa33c03b88750dcb0b168a347"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32edab36918a5286bb3b571d38459beab304d4c30632ac7d17bc6b94964a6485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526c8738c5cd0c1386f7435c9cc5342a7a65ab05e5562c3c9bc92da9068b0daa"
    sha256 cellar: :any,                 arm64_linux:   "55032678e9148ef229a7282f14704addd7ddc771f52517349bd8721de256aa74"
    sha256 cellar: :any,                 x86_64_linux:  "b5982b4f03c7c5e69c0c662956d586a92b0cdccd6396212cf292e621d6164ce2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    (buildpath/".cargo/config.toml").delete if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/unifly")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unifly --version 2>&1")
  end
end
