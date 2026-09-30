class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.37.0",
      revision: "c83f3a27cfa5d962ffae08727eba8351700ca5f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2ea73af3e59a240760e70bc9803b9fc08347ad34c7a8d29cb8b1e3c661973b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91339355d82e4ddf1d35f1618e9dbcc0603c77b4d0deeb3f82ce7ed7f2c970f6"
    sha256 cellar: :any,                 arm64_linux:   "12e590f1b7a7a8f30e64467a04c07290d9a48b00b9c8eb798acc4620107b1537"
    sha256 cellar: :any,                 x86_64_linux:  "3d41ae961d0f1b2e19775ea873d63a82b1161303f4c7a490c0a4634ea09dd6cd"
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
