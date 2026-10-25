class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "191bd6e24d1c5ae79d4b6deb4f4d705d0516d01a44f5287e2103168711c08fe6"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b5c0f5c295e6d34a538440936ac26b09829b47b74d140acd2204c08110fb6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697f956137f06a15465ecb18ed698bd81fe6fad4074a49b1d8a85c4ad1d851e7"
    sha256 cellar: :any,                 arm64_linux:   "81d362d9297ecc9f182272667078e56101d448c20a8b07d25c2f9031049c8302"
    sha256 cellar: :any,                 x86_64_linux:  "3085882d0dcfb81ffacd450d890a33989f23b7194531523b889311a7962f1672"
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
