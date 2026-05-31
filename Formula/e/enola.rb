# framework: cobra
class Enola < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://github.com/TheYahya/enola"
  url "https://github.com/TheYahya/enola/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "c48b934d95e1b6006ddac422a689e2d67d8bd81f2b47a4d75389483ad3644520"
  license "MIT"
  head "https://github.com/TheYahya/enola.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0921f05dd670bf94751b26018782f9833c18316fbdd46a6f9565aa96ab950aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0921f05dd670bf94751b26018782f9833c18316fbdd46a6f9565aa96ab950aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0921f05dd670bf94751b26018782f9833c18316fbdd46a6f9565aa96ab950aa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e371701fd168986711ceced3aec6db521550aa1bb47de47112adf035426eccaf"
    sha256 cellar: :any,                 x86_64_linux:  "e9a3a42e63a0c633a38fd81f7e9df2da7229597c5fcda76e7087d58cb97a1aed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/enola"
  end

  test do
    output = shell_output("#{bin}/enola --help")
    assert_match "A command-line tool to find username on websites", output
    assert_match "--site", output
  end
end
