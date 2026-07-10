class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.29.2",
      revision: "657ba711c2d70f27f8a06a12a0b770c4b4b3eef9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82178c15f328d0090707bbc0070a41ef1b60d22c1da4949186233e0e79ac94e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e024332caac9b0509ffd1dc2f078aa6ea5c889d497bd5034681a369f96ddb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4f4deed7a39d61dbc80cb13577a9c68d2b9952bca777c4c01ec7bf1ea8296b"
    sha256 cellar: :any,                 arm64_linux:   "12faeaa758bb376a3fbd64361fe26ef87e29414f65ea2393f0267b700d10038c"
    sha256 cellar: :any,                 x86_64_linux:  "bf40c9fbcbe514653bfbf01f061391e91ff490b27968c35a035bb2e56be31e52"
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
