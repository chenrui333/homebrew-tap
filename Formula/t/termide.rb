class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.9",
      revision: "fa56843ec95bb05df77b4bbb76074063a8cdb5b7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ecd0ad82d6d813d0a208e05bb0b01134adb0b55060bebe460d3bcefcc65cb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "744bd4b537301b65f699eb12e1343fe07ece39ac96d722bfe830f9fb9ba8a7f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f941b562fcd07488a4144bbf8942beb47ffe0176f48405b906b890f2782eae2"
    sha256 cellar: :any,                 arm64_linux:   "7109b16f383eda112bd1d50691bd9867019e0492878d277ccdc8aeaefebc868f"
    sha256 cellar: :any,                 x86_64_linux:  "cc0682c875cccabbdce0ef3b00d5479e4934199c4f1da84a34d41831a6064418"
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
