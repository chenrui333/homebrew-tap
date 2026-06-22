class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "653d235c75797c271c95c5cca4dfdc1569c1d0a215f44cc53e7605efc8fd8ae3"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87bd45c43391f4f8dfdd606dcfc72436765562d874e2277cad84733e57f0a907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac1799d849f0aec7c5d1e01d1588986bfebe144a63c809770e5224f6fc568b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387d503230dfbdc8aa5fa918f190d2508c4b7947e3492c06e511163ac1502def"
    sha256 cellar: :any,                 arm64_linux:   "1e48c545e96095b4e5c897a7d8e39baaff586599c3c899de2a371a4c24527f7b"
    sha256 cellar: :any,                 x86_64_linux:  "419a740615a4921785108926bfd848644d0b11a99dc4768c7f0568fb6888c9ab"
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
