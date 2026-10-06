class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.39.0",
      revision: "5c550fc94d9353f6a3b1c88a60e14dfc89aa555f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c45a31fc845dcdd7a6fe39a4cfdd1cd55f9aad77fdc9face3b7028f83efc37db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f45a1113b00a4d41c8d4184c66d15082d420c52aa2f59f7e80620c5ec6c7009"
    sha256 cellar: :any,                 arm64_linux:   "83538b0da78f2e97c49b3c5b7e6e722b49fa9620f0b0f1a3195fc4f89db87f4a"
    sha256 cellar: :any,                 x86_64_linux:  "61bc51f37290beff5fc32633daec0c241722497bfed52315fee7d6b8dd770eb0"
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
