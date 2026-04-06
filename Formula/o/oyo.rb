class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "c651a7eb10a2e19055c54be40002699e662abcf68ed8c849649950cab014b362"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cea5691b42d6204ebcb095982159efb58c433a7f12d3f43361c0d7637942f13d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032cca9e4eec01a6e1cb96f8fa07670aca510c8d2cf2495d1f5e8291e3523d12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "394186e93983c0d6814aa91d6d1dd1d74215cc0f73c7338f49b13c55610369e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7cf80ec47efb60499f8670282d970e3dd4c37166062816fa9e1080570f47c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4d8984e13dae220683f4e8271ff57d25e197228d8549efb9d10177377f591e"
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
