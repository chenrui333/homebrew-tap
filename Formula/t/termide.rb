class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.30.0",
      revision: "03489f2cc9b7046a107e8896be3305f2287f5fc7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e71eda5ce29821e3e6988907089a6b7642d77f095d5df1763721bc08a8c29467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543a9f34df413c102cd4c13910ebaf3eadccbcf4baf00ed3ac25af5fa4b3bbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1cc7fd06f568269ca9db8bfa3f4e7eb6784e3efec632424522e101e3a6aae0d"
    sha256 cellar: :any,                 arm64_linux:   "6f1bd0f10633e68bb1159e3c73a23424ad36fc4a100addb0bf36aa33a0791e02"
    sha256 cellar: :any,                 x86_64_linux:  "eea584276fc917242ba2f40796a31eb3d0af4af7b5c414095d4f4ca0e02dcd92"
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
