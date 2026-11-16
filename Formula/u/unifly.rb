class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e1ccaaace6c5cb64b88d9f70264655b1ed197f6fa33c03b88750dcb0b168a347"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138e8024a76deba7814df85c2e088c2d981b85d3c324ff6d72cfd1bac69b25aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0c84c102a551ea58834b1ce215a6d60ced778ba59f1157df122d2271c325e84"
    sha256 cellar: :any,                 arm64_linux:   "ce06caa3b8f141dc488c845fcab9c770817fb9401ca56fb0a3ccd466ad89074d"
    sha256 cellar: :any,                 x86_64_linux:  "3118c151caaa3429d42dd24938635d558cd3acb6b34fdaa92f0923c1ed27bafb"
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
