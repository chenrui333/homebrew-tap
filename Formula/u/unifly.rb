class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "2fa796a286be42aa81d41fee89aa481a155f5e02aa7dda1a0eb95b7a325b9b69"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da9b86de06ac3c64c5e52a658c0e951225cc144a4a405e6df138e40d393f9916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f065415f7759f9a364261758f5439299238739cb95ed594cab803c2cb2ffea48"
    sha256 cellar: :any,                 arm64_linux:   "22f6216722f27f69ca6ebe34aa7bfbb3596f7e99c2ef83261583c247ae9f2b5c"
    sha256 cellar: :any,                 x86_64_linux:  "516afdbacedbb35240214e02032dcdc1e387f832dbf38b0893d3c26bf635d7a3"
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
