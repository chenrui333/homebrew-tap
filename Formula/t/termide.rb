class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.46.0",
      revision: "1928b65c3ea403453964f319eff6147d6ee8293b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a4792610061d94b3fc31a0fa9e96a8f821c0a637fb6b05d1da6666f3bb97edf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c84982717da65c152bb993024513856f8e5ba673b6c792c462beac6134c97a"
    sha256 cellar: :any,                 arm64_linux:   "65cd18e0c0d38dd787e8cc0f454137a4b4db68c6799ac87857626ce60975ed04"
    sha256 cellar: :any,                 x86_64_linux:  "4f96986aacf4bada579e4459cb1da9f3b042f53dfc30fda0a61d3ec06e9708ab"
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
