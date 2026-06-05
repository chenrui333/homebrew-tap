class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.11",
      revision: "0ebfc95f1565b5a9ca5172b1203516fcef8a4969"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de8faa254d1cee273b390bb614a3ec60da4b09a59999945d80797bf80c0597f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531110fb4f194886dfebe86ceb2e014f70baca5c0b638f3976440210482b902d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "437857f54c8eae1011ad5ccffbfdefd4d3e03309a7334f1234928a1406dea310"
    sha256 cellar: :any,                 arm64_linux:   "9801569c679337e207eba2ed330d66485d1d9ed3cc2dea3dc2327f6803e37e02"
    sha256 cellar: :any,                 x86_64_linux:  "9690945abafe6127ee0b07508a830481888e8b1b41092e0cac449df4931a455d"
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
