class Travelgrunt < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/ivanilves/travelgrunt"
  url "https://github.com/ivanilves/travelgrunt/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "ad52294a93d7a06e2c551e0b29b03300790c91cf547440547da48e4406c0af0c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ivanilves/travelgrunt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbd1b96a4502c1abbb9ce5453d81da57c8ffcf29493c7185ecb0443e3ac22841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cbf17ccb1ca2b285835ebaa11f898a833d404cd80ee2b8668d247a99123272b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeb656d73b0c8591f50c89fdabbfb37d4dd1cda926bca902f8bdd8b9f0cfcec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2809f207dcc3b3a787698bba858fb85c86ea748913424b914dca7895164f5cc1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.appVersion=#{version}"), "./cmd/travelgrunt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/travelgrunt -version 2>&1")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "invalid"

    output = shell_output("#{bin}/travelgrunt -top 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
