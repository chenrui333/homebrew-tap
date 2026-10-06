class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.39.0",
      revision: "5c550fc94d9353f6a3b1c88a60e14dfc89aa555f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "194f3fe5b655f316f982fd958a758e59b7b683017e9e41ba10722ccbeb2f64fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99aa6e8458af21027a83405f2832f7babaeca21c0d53d1c68366e8712c245634"
    sha256 cellar: :any,                 arm64_linux:   "12d4aeede3776271b2fe3353cde2d8057049e2738de31b005d0fc6696b359877"
    sha256 cellar: :any,                 x86_64_linux:  "b4ce9fdcc794329656f06a1349908e22c3d5ce30d7d2713f8ec6596931f6687e"
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
