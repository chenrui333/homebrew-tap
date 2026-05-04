class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "db0c06eef491cf689cd0d1b683ea47bf5c79dfc664413cccdccda263d7fcf5c3"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21ac60cb5d3e936fd9b7ab5e560c722f56185b93bd51b931cade12c4895d1464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21ac60cb5d3e936fd9b7ab5e560c722f56185b93bd51b931cade12c4895d1464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21ac60cb5d3e936fd9b7ab5e560c722f56185b93bd51b931cade12c4895d1464"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7e234a9e642ee3d5a9c03aa28c0504636cae31b755c1a96bbfaea5f925083f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d2a4d377d4c527fbf89d6bde5635e3d0325756f13706488bc4b77657f63ed3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pphack"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pphack -help")
    # output = shell_output("#{bin}/pphack -u https://edoardottt.github.io/pphack-test/")
    # assert_match "[VULN]", output
  end
end
