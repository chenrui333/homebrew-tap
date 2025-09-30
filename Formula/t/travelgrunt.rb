class Travelgrunt < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/ivanilves/travelgrunt"
  url "https://github.com/ivanilves/travelgrunt/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "72260e10402d5b4026ed130b203b8dd9ba0899fdde29396f037eb0941150dd71"
  license "Apache-2.0"
  head "https://github.com/ivanilves/travelgrunt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04e5ad4e9898105207d03e13b4a1c59790c701609638ff400f8f8a5969f7521b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28c7cb0af0d3f41b4f8105bc118760cf895bedbc6364b5dfb01aef49e16e7e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0eeca9a7a2c714cae8c24ffd794b9110b7465a2e26cfa4a5b08560e48947354"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.appVersion=#{version}"), "./cmd/travelgrunt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/travelgrunt -version 2>&1")

    output = shell_output("#{bin}/travelgrunt -top 2>&1", 1)
    assert_match "failed to extract top level filesystem path", output
  end
end
