class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.54.tar.gz"
  sha256 "7873cbf11ee776785d4cd038fb25f34f7f2e59fd00e48f6c607ee27a7e9bb112"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d196421c178f2ca9881e77c4295b16cce05b6ee88c0e0faa8dd39bda35ed897e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbad9ddc69222993a2102b27f8a123ef972580e3e1eabc2d25d6d76eaa49eb32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "174eaaeb5fc90ffd1d828ed46a67027982faec66afe0b0882a3cd38a4cef7609"
    sha256 cellar: :any,                 arm64_linux:   "7660e8d7730aa397240d56addba752fc0b8d58ea5c5e1e83084d0bf53062fa0a"
    sha256 cellar: :any,                 x86_64_linux:  "989f5d418f92dc1a4a4ce5bcbe20715eb9d3a9265b1b746c3e8b4aa0d1112e5a"
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
