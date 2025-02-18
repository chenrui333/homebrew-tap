# framework: clap
class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "ebdc68fe26fbec05325cef762ea4969eb8750dda7279f0008908a4ac8501c3ff"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8006f3738bf217a6d9d1181de4b6fbda37b71d687eb0a4caab3ec80f01a93f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d17f116e1a8baeda08214ae4680abce6d7d088620b7804f17cdb5f44ba5680aa"
    sha256 cellar: :any_skip_relocation, ventura:       "8525e1993b4a2a67e61f1f258557fd902634dd040eab3443bcb90fa670dd1d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "332b5d9ee1be3479dbfb998a9eb3c76a143c126557bb108cdbe5cfa4a0d96aed"
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
