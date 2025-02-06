class Alacritty < Formula
  desc "Cross-platform, OpenGL terminal emulator"
  homepage "https://github.com/alacritty/alacritty"
  url "https://github.com/alacritty/alacritty/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "aa4479c99547c0b6860760b5b704865f629ffe1f1ec374153c2cd84e53ce5412"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c416b19bee072e30da1a2e9224c976b82e5434f656ba3f8ae3f68326f894aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b757fc738c35ef31b03f8f921c1cb3379ef0786d631731a84d9ef71d1b31885c"
    sha256 cellar: :any_skip_relocation, ventura:       "14aaaf3ff042680531d69122ef1190ceacaea3180402b86b882267187fbfe374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff1dbb74aeeb9865f0a8194e34aeb6d9b141fc9c06866a846d3aa2f0ea45afc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "alacritty")
  end

  test do
    # it is a emulator
    assert_match version.to_s, shell_output("#{bin}/alacritty --version")
  end
end
