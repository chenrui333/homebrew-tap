# framework: clap
class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "7a008e64b9dc7ebe2bc4e39d649aaee37f0f9bbb813bf7421026c1226d56874e"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c446f191c46dfd67a87fc49eaeab2cd45f0ccc07b6ddec4f24429c353da2eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0214958f7ecb5aca470d4576b8211b170726e9fbbd5f6a3d301da0d1a5c5a893"
    sha256 cellar: :any_skip_relocation, ventura:       "3f9d65a9c045717520912053428ef2658357ad2772f34b10362c66c02e01ba29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34de8330ea3f338257f683db420da87d6e3e25056a3d24946b9bd27a41e51d74"
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
