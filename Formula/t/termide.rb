class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.46.0",
      revision: "1928b65c3ea403453964f319eff6147d6ee8293b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9a7d5247a8fd31f32b262cdddddf284db78cf2fd3ae4244f495df428022d42e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0936fb66608ee44fe37f851254c17d39b882cfde215233093dbe60cdd8b46db4"
    sha256 cellar: :any,                 arm64_linux:   "02a8554bc07fdab43871d8d38399e82595442ba9ba9e8c7dccf09f0db8d2eb9c"
    sha256 cellar: :any,                 x86_64_linux:  "0d4662504c241678a0566b815d8d6449a248eafde154101af4c2f3ae8e7ecce8"
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
