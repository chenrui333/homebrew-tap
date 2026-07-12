class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "67653c3739c39283c45e2b3a61b7c1061e22d0f207d3d91c5307cad40181d54e"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce93cf880f3c46cd3f2770f3b182854baddbeb313238954931b76ab2fddc75d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcb0882b195869cd2486801abb753857d2befdcb9518ab4ba9becb58ad07e2dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80468a201a1d4196e7e6b013c0db1f0953f666cacfd1149f85472b636b712642"
    sha256 cellar: :any,                 arm64_linux:   "f952846b48a1b8556e9deaf060b07368b27c75eb220410724c3b12e408abd227"
    sha256 cellar: :any,                 x86_64_linux:  "812104136da01737b3eb86977105259d8fde9efd47493b9960a342d1ccfdd521"
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
