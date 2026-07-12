class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.46.tar.gz"
  sha256 "76007a005f2debfc40c3b49e8ac4d1f27329e5d1846b5cf517812e8950b73e4a"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ec13ec8cb2a79041eed907ded91e4e1292ab433185debdc804515975bd801c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363a551d5be1d85f8f5bfc30dfb82ad3a7190070595c0b205fcad8df552a2fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a368dd420ade3f942840f5507d04c640a7100e9f880dcb328a545e11d7df32c"
    sha256 cellar: :any,                 arm64_linux:   "92e1b05253f38e5e592718ee09320dbacaed1dcac17f6b73cbe3dd234c8094b9"
    sha256 cellar: :any,                 x86_64_linux:  "5af70b01e99014bc42971042d86836ab5119b04a84d67cbf271208920d1f9ffe"
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
