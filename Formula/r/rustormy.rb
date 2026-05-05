class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4da7f2851fbe4a496d0a01546528421a9a42dd6d93834b9e12056871e1ac9a6a"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e70a9337ac5cb2d86ac0ba9550bffb2774c6b3945eb15cc1405c899ab75bcae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e98c811ea79ee3d9369e18ceea64a4edb0d08b3737529dfcc7bc1b283f585b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e49e26587834f9af40dc3261c9709e19380ee47d8cfea41be1e062d7d80af577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dad512766273d7cab5c2d6eb676c537ac2795e592b30dbeff9805acc64b357c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfcbf9a0f00d7a946ec5b9854d4001ea13db8b981b0a5a488a43c0c46a266b06"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustormy --version")
    assert_match "Cache cleared successfully.", shell_output("#{bin}/rustormy --clear-cache")
  end
end
