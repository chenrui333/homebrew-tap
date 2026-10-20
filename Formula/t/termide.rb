class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.45.0",
      revision: "ee917ae74ba35ede5b6c120874aa1f415ed29a46"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ae1f9de4b8bdc7ce378838eab3a106f724fce9894f9df620ac8696b36ad8274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a54a2c38c70b874916398bf7951926771b236df071e3228a990b2f0f292b4dd2"
    sha256 cellar: :any,                 arm64_linux:   "68077316b1293750ea596199a18845aa805409e2ce6815af983dce23957a6092"
    sha256 cellar: :any,                 x86_64_linux:  "0e2a0e0a8d2614bb0087d6a779da33e3894660b9c6f05ac4ee988130b0b8995a"
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
