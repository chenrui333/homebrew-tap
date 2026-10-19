class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.44.0",
      revision: "8441007c304434b3f160156966388856478aa9bd"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa3d76e906773a920b85f4867f36144ebdd7b95cf74b9c554406a0492f2977e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3ea8d28a8361f9eae495d177dea96e735bee5b57a5eb078a22c15442718ae35"
    sha256 cellar: :any,                 arm64_linux:   "86b5e93cc055715a375a35b4d99bb1c7522797c060b36e2ef355d1896e23557c"
    sha256 cellar: :any,                 x86_64_linux:  "5e7bb7b1ea25111a61db79c21b5b1f6c55389c5bf5d1ba2001a384e75c6da5a5"
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
