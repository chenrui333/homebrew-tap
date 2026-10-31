class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.48.0",
      revision: "b1cccf8d84b12b0498ad3307dc02a3e26771c536"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5499cebd03533c840fa77a639e9698952673ce76fe4d0b772730365f20c196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a84c0aba7bc1458d3730909d8216cdb932159d7600daedf842ab827668733c8"
    sha256 cellar: :any,                 arm64_linux:   "dcfe12dd9c2625788f0bf1c0740bfaf716124544aa663526af5625f8b48eef5d"
    sha256 cellar: :any,                 x86_64_linux:  "d0ded17a8feea4d849bfc74cb3f6418ea8169ea971b69b3e2c49e96012d3a148"
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
