class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "7b8fde4d6825c4811b843e99b3c353fb71ccb09432aa0a2dc648d814b4e3ec2a"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "033c89a5a649ca719aaff50dfe8fb19074d5dc105529730d17d4a336e4602bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033c89a5a649ca719aaff50dfe8fb19074d5dc105529730d17d4a336e4602bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "033c89a5a649ca719aaff50dfe8fb19074d5dc105529730d17d4a336e4602bdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd70d2fbc93f288594235ea376ed77ec960018ba32e3e3822cf96c48efdaa4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d0754510e8afb9549434f2f099c6cd81e0582f9d80e767f81b2ddb0b39d293"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"claws"), "./cmd/claws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claws --version")

    output = shell_output("#{bin}/claws --profile invalid/name 2>&1", 1)
    assert_match "Error: invalid profile name: invalid/name", output
    assert_match "Valid characters: alphanumeric, hyphen, underscore, period", output
  end
end
