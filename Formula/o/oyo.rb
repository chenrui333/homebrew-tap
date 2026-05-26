class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "9b36f1b90605c5052b14a6c0d32f5ebd7249334893a5ed2ed9969325827adf31"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5475aedccf1c5f961185b07e5ebe2cc792453c3acab660dfe8cc6b3676ff1263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450e70b031ef79e3e4d055e1d98d2e6603f846b363d6b5a5b27584b2ff4194e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f92c516360b076c0e0a456e2e2258a6038afaf5c75f707784d7b8f184879e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c915a9c2f0b3850cfe93743761ae30ca0ee6489175067fc5408bb0e11f7e0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a4364865a513dc6fb64991f0ce1e5a20360bf1f90ca94a241a5fc55ca83845"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
