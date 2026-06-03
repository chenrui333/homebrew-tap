class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.8",
      revision: "3fe77a17222971da6f99f127211694d089f7ce20"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56ab49a9319ee3a94335eba735f06dd680caeb8d7c6239e3ba9bec68627bff11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf879aad34a498d11183250d44b7192fc046c0339a7b3f52c27dce6f1aa7c98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35533f3f6bf1799438d0972ea3eb25e9bedd92f4928cbabfa706364213320d2b"
    sha256 cellar: :any,                 arm64_linux:   "89c5604c60f6949e438ad030990b803e1d6b7caaaa6c4b3d120e73307610f985"
    sha256 cellar: :any,                 x86_64_linux:  "d51956718b7f0af71baf102545a0164c8d1ae8259e79a6202bf4ab4fe5d323a0"
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
