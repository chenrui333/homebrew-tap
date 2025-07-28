# framework: clap
class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "cc07ad9b9a505f2450d6bd6e13c704e53b49b6ce77283223b51892836774675f"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f14bf55250880dd608b3375c04d1dbd9e952662f14b6ca5dab7957865c1f8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "347591af4ff2596fca07de9149e16d220764382f9cb85e87071bc77d6a3ac80d"
    sha256 cellar: :any_skip_relocation, ventura:       "99cd030bd7a1b3c8f825dd7f8b59d48ffd3545e8ecbee64d286eae01462c7774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f621784d3df88b8755a271f4c1f0bb42e0f4218bea44bea3036b62a95624ff01"
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
