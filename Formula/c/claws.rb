class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "05cfebcb159d30f9220f5a170bbd54d70a8db69c77cd163b801ea00e3bccc825"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1804ad30d073889a323c3058dd8ab12a8426e6e6582bb03513862b21a6d315d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1804ad30d073889a323c3058dd8ab12a8426e6e6582bb03513862b21a6d315d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cf97ebd1cd9e2eaadffcd145860a93dc7f95e2f5ec96f32a56005f949f54b8c"
    sha256 cellar: :any,                 x86_64_linux:  "f1f757c3f24d2935df293f8e1dde8f423e14e62d4e964beae75bc26f9addc4e8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
