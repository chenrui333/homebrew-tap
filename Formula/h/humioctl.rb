class Humioctl < Formula
  desc "CLI Client for Humio - Stream Logs All Day Long"
  homepage "https://www.crowdstrike.com/platform/next-gen-siem/falcon-logscale/"
  # v0.40.0 was re-tagged upstream (only `.goreleaser.yaml` changed); pin the tag commit
  url "https://github.com/humio/cli.git",
      tag:      "v0.40.0",
      revision: "154b317c0293ea7776596f1c5d8553469e8442c2"
  license "Apache-2.0"
  head "https://github.com/humio/cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "672b695ececefe32971b13a5a9192ace9aeb85bc315ff062056fd6173e42dbc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672b695ececefe32971b13a5a9192ace9aeb85bc315ff062056fd6173e42dbc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88e564a1092c5806a5c8a74fbbabd616645d45e79fdda3ede950a0f264fe8a7d"
    sha256 cellar: :any,                 x86_64_linux:  "70215572650518480ec48f5cd16162a232e735f0fa58628aa3ca097ce6b2b3e3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/humioctl"

    generate_completions_from_executable(bin/"humioctl", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/humioctl --version 2>&1")

    output = shell_output("#{bin}/humioctl status 2>&1", 1)
    assert_match "Get \"/api/v1/status\": unsupported protocol scheme", output
  end
end
