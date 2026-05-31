class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.1",
      revision: "cc25e0bb0654e7ceefc2823ef2081114950770a4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18a7a9b47915dc110c0269a1f75319e83e68ccc641ed265ff612f87da928472f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7570da27b377577850177c1534289e1a7418d0f915555df2d2bf4a0086b62aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88325db87c307a186fc7d54ec358d9d1264bdb2cab700f1c555843f40a07aa12"
    sha256 cellar: :any,                 arm64_linux:   "dd11fb0c797084355a527aa6d7466b600d3c75c8090c6900a48363cd5bc13207"
    sha256 cellar: :any,                 x86_64_linux:  "28a72b179a345f3aa98fb49f66b2a6a63a984d6565285326a1e454c4736ab59e"
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
