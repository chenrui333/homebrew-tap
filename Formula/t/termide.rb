class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.3",
      revision: "10aeabfc024332fb2496b632d380ccedae2597ee"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40fb7aa300ee7f9bbbc522ed6528c5d46d960b99f8c58b30638b85bc0c865b33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18bda88d63c83b52cbcdd8e28f8792d441ccc4a9a3c0264aae6f2cf98552052d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db6ccd0c43562df7032d0be7c233b2f39a59dbdaaeffbc6efca393c8f7077f28"
    sha256 cellar: :any,                 arm64_linux:   "22673d435fc7940e353b207cb8a2fca2e55a3f4e4949b3036dbba4e6bb1afb15"
    sha256 cellar: :any,                 x86_64_linux:  "dea9c3b677bd23c215545fd06c75873f74c464fb2537d91032455c87db51c34b"
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
  end
end
