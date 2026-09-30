class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.37.0",
      revision: "c83f3a27cfa5d962ffae08727eba8351700ca5f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01ecc4402af7f2e0559664cd42f001875414f6027e78d647255d16277669221b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2975f8015cb31e6a4b3d10596718208c3f9a7dae920e5437e10559f3294ec6af"
    sha256 cellar: :any,                 arm64_linux:   "7692d46e8603e46a6aa578c005a898230b747206d2d87c069a73f78f34a31d8b"
    sha256 cellar: :any,                 x86_64_linux:  "16727f764e7c43afe4370f40bf047f7916578d790098ef60745da636b79ff112"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termide --version")

    output = shell_output("#{bin}/termide --config #{testpath}/missing.toml --diagnostics 2>&1", 1)
    assert_match "load: No such file or directory", output
    assert_match "One or more checks failed", output
  end
end
