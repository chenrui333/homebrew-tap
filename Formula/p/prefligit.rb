# framework: clap
class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "76051cfc51621edb576f3cafce2985b207f5844b01ee98c469380b3d7daa1cc4"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef9f7683ec6e241a3f907d704728e6aac0f773959572fcb25510c569cf09d2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d44fea863fc9b56f47493c9f76d5e02fdf74dfe105a5e316f7d605d6af3785"
    sha256 cellar: :any_skip_relocation, ventura:       "54e026452d77a6e59e9888d9dc668a4dbad854bb73011034b0373a5afd899dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaad6a0da67fb87d595b9fb7b9781dae0ff78a14cc321fd0995e71d0a131e49a"
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
