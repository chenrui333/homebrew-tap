class Travelgrunt < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/ivanilves/travelgrunt"
  url "https://github.com/ivanilves/travelgrunt/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "3a97f1c60f107507e965a826798c38e511a02462c417d1dda8fd619590c22aa9"
  license "Apache-2.0"
  head "https://github.com/ivanilves/travelgrunt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27948d32e9cc62c45829a6a8fc0d068034b3243bacaba0b2a3c1fe4f1970c56f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b634c9b04eaf6a6b3d81f0f93629f3cca6f562ec6c610c3032fbdf531e65e593"
    sha256 cellar: :any_skip_relocation, ventura:       "98d2d929c4111f147fbef26d184d78e1dd9651656933ddb9d53c7eccac079d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ad8d873254e669ade657fa9c6ddfe99028ea95312a3931cb0a8e4b8e30afcd"
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
