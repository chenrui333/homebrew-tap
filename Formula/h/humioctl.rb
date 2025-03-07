class Humioctl < Formula
  desc "CLI Client for Humio - Stream Logs All Day Long"
  homepage "https://www.crowdstrike.com/platform/next-gen-siem/falcon-logscale/"
  url "https://github.com/humio/cli/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "0b95168706f9df0a8d8a248a7e47d9ca8cb4a3418bc33b5ca5589f19139ca8f2"
  license "Apache-2.0"
  head "https://github.com/humio/cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d1bb56270649a93ad29c4dc9e5b30b3a26bf090d29fc9c5ccaa69ccd81f4858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "606663ce89be233560e9429261ad24e5e5b2d27703ad4fe7e4ae53c68103ee9d"
    sha256 cellar: :any_skip_relocation, ventura:       "1a2b3ced21ba65c39ceb0b8b44c049a3477cbfaecc9b0661c3f0e10db3c674d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a0c102fad4c6a570ddd9eb17959201dd6213749c577c7f3adc4faee2bce5de"
  end

  depends_on "go" => :build

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
