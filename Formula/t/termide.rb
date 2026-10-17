class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.42.0",
      revision: "02e2bccdb1a091134374efe46a0a7b975ec3523d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b16932e8699cdc56e2e61790792156ca2500cdb9cb154cff625afdb891e4a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59403fd3f1e3cd70a288afde55395c307f923a78ffa4856f411a39b33e9894af"
    sha256 cellar: :any,                 arm64_linux:   "5b49034c149a959b5eefe15b8729a1fd271972135ab5ba240d2827a553af9cf5"
    sha256 cellar: :any,                 x86_64_linux:  "12b9317e7921e52a1b060b290df8babfe213715bfd74e2a6ad76e0a6dd0090d1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: config file not found", output
    assert_match "One or more checks failed", output
  end
end
