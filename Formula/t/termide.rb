class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.50.0",
      revision: "a4feced82e683fa74cdecec87b772fb9edb951c6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7a5a603201007e9f2915f98eb31a265e820487b415c89d60ae7503251bd3d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1406e50b0e5b84f5bfca37f03fa724992318b565f87339f714707c1d912400"
    sha256 cellar: :any,                 arm64_linux:   "c611db1e17539be002e35b40fd5ebd56f74b3c30a328879edf2abed749665d2e"
    sha256 cellar: :any,                 x86_64_linux:  "00624774d5ac4364e3ac3f9c98fa372d3402da7ec07a6b5c806ac5e2b04c23cc"
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
