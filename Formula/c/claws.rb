class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "93fc3bde4409475ae48d8924dfaccff5b231d0a5cb36034b81b556b361bed1e0"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf17f1656505504d417856e5ac7240ea7755c38ef0b2ad6b554a1f87b94b7bd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf17f1656505504d417856e5ac7240ea7755c38ef0b2ad6b554a1f87b94b7bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf17f1656505504d417856e5ac7240ea7755c38ef0b2ad6b554a1f87b94b7bd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a1cb90154b891fe4e9440daccedf5534d2c7d65d8518d0c17c5ef7f2f36a2a"
    sha256 cellar: :any,                 x86_64_linux:  "04d412d33d3ae6f04dc902b1ad420d8031a6609eb07991dc63549de096228e76"
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
