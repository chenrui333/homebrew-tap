# framework: cobra
class OtelCli < Formula
  desc "Tool for sending events from shell scripts & similar environments"
  homepage "https://github.com/equinix-labs/otel-cli"
  url "https://github.com/equinix-labs/otel-cli/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "331a76783974318a31d9ab06e3f05af488e0ede3cce989f8d1b634450a345536"
  license "Apache-2.0"
  head "https://github.com/equinix-labs/otel-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a1abdfc3c9a26b4c3065f6f2be4d3d31b6b3f81bb82bc571512dfa4756dc37c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76450a7f24f407f3ba61830a37ff270cce5ba3ed0019bfbdef31c7947ad14724"
    sha256 cellar: :any_skip_relocation, ventura:       "79f100f4a787d528f01410e2a102c383b3233b343a7de78b53397ebf83d7b4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeaf21b45ea2c36529799c242c6160ba05a90dd04353c9b6e06dd1420ccde447"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"otel-cli", "completion")
  end

  test do
    output = shell_output("#{bin}/otel-cli status")
    assert_equal "otel-cli", JSON.parse(output)["config"]["service_name"]
  end
end
