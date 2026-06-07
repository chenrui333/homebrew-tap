class Termide < Formula
  desc "Cross-platform terminal-based IDE, file manager, and virtual terminal"
  homepage "https://termide.github.io"
  url "https://github.com/termide/termide.git",
      tag:      "0.24.0",
      revision: "d6c3cb370512bc5d422cd6984bc454550112f99b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8bd43e0e331da910893472500710322817cc7d3b7d148fbaf366a6b1d71f573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94006f34bf875067c57d4467605630e5e97bbfa9a8828aebba431a356709ac5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ed917d4e84d3bacb22f66980e6fcfd4df9e3093ce95aa77781b6040e087b271"
    sha256 cellar: :any,                 arm64_linux:   "b2c4c93cade64a3f9e8fb684827f0978f919f3a1c40cdb16f33b3af39249b59d"
    sha256 cellar: :any,                 x86_64_linux:  "f8feb913318bdef247b42641772bf8f95a476da2ab5a76cc8feff1bc88587076"
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
