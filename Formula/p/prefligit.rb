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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a14fee2ae7c41a42a2c012488501b00ac18bed523a5714d484c81df93f15809c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21ad140af0df6c799db2563ad5f46e67f57d435a2410c5a230b709fff420047f"
    sha256 cellar: :any_skip_relocation, ventura:       "c06e10080adc8798365038947a45a2a5082f69280fd2d2c51767c60a16c867a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55595a2092c16c911d130c0f5bac1bb7d8586f7911c0c5f90ce4eefc025290ef"
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
