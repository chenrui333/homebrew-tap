class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.56.tar.gz"
  sha256 "8db94c4625b9fce585b75508f0a11b515d05f61f8cf499d466ee5e922d00f676"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "426992ccc0ed30b0e675143a356960c5a6b4206196d45f4b05a8cb8bfffbc49a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "771b59c3d98403e16a4ce9adbb0edec09c1850ba5c5786af3cbbac0825ac63f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4987c43a8ce5bc977176bbe5d77536065a0ef38fdfeb53e7bdc4fa2c8ff018f2"
    sha256 cellar: :any,                 arm64_linux:   "e15ab4ac9b04ac0d0b0ed94a42e7c31603b3913ea76a00e86d597af43d358bfb"
    sha256 cellar: :any,                 x86_64_linux:  "74469a423d53ce67e08047be26236982b3307f11e0d2d7265f03592d1b24489c"
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
