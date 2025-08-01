# framework: clap
class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "5df1bb2c4b8ff1db4f7476e463d5e551cabca6221a91e4ed308b85e651ccfbae"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c075d745129f863d8fac191e48c013cab33a6d0a42194e0e9993e655bba9a760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a953cd1d94778da20f9b36e5a513986baff583f7951cbf7499f87a2c11a7c01"
    sha256 cellar: :any_skip_relocation, ventura:       "56bc31a2e12587cb9197bb5fbd5d024b067436809d420f7edaf1bd62a01fbb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c56619acbd459f6d45f23384f5a5fb4e63399736c4c7cbb90bf1e4c5cb05cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
