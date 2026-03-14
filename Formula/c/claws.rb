class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "7b8fde4d6825c4811b843e99b3c353fb71ccb09432aa0a2dc648d814b4e3ec2a"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5732c1d8266e7c0bd807bd4a2558ad9e1f922b8d45d925ca042648e41a56518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5732c1d8266e7c0bd807bd4a2558ad9e1f922b8d45d925ca042648e41a56518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5732c1d8266e7c0bd807bd4a2558ad9e1f922b8d45d925ca042648e41a56518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bba6442b79a820f3ceeb976ebd194bc187212c1db40b2c2de67cec8bf61274a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7fa5d419809303b66a58ca9c8de5210c6833d37323689da65b798c16180a4c0"
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
