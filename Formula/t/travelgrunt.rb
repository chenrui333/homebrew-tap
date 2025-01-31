class Travelgrunt < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/ivanilves/travelgrunt"
  url "https://github.com/ivanilves/travelgrunt/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "63dad712085170c146b3c764f305654a419d140f65d02336c2e87c6f13da37ec"
  license "Apache-2.0"
  head "https://github.com/ivanilves/travelgrunt.git", branch: "main"

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
