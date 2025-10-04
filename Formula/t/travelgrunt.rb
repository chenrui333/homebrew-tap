class Travelgrunt < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/ivanilves/travelgrunt"
  url "https://github.com/ivanilves/travelgrunt/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "ad52294a93d7a06e2c551e0b29b03300790c91cf547440547da48e4406c0af0c"
  license "Apache-2.0"
  head "https://github.com/ivanilves/travelgrunt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b654f65eaf2bf94bdb667d8757678eb82157e58fbc9749bdac7d46f3c270fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a682ca425c13a65c10d26dd15b141abe237d95ef4eafbe0dd617f52732f18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58313e098341e3a0812b3138af4a3f2aad916df7d964d5f8496827f7f8b54f2"
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
