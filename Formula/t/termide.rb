class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.23.8",
      revision: "3fe77a17222971da6f99f127211694d089f7ce20"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d226a0e3846de11f4be98bdce49e0a1ff2a264f6a210dcc1d0555350b50621f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48dc5601fbdbeb8cd01338c847822ed1b6525279c512d372b7396d228200f0e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a1361627510c7d2b571938d76a37deeecdb6f68e1463dfae9d55233714b36cf"
    sha256 cellar: :any,                 arm64_linux:   "15cf0ba42ab4b6cafb7f492fbd4389981f1a4e75a8304c9fbdaaaaade8647efc"
    sha256 cellar: :any,                 x86_64_linux:  "795dfbbceb14fbf83383201f6d760c24f7d2316c78f412aba9f9205da67f7a50"
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
