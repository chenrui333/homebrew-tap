class Humioctl < Formula
  desc "CLI Client for Humio - Stream Logs All Day Long"
  homepage "https://www.crowdstrike.com/platform/next-gen-siem/falcon-logscale/"
  url "https://github.com/humio/cli/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "d59bbb35b005cd1b606b87f458ba9b2ed4ef55113ed273e6c7ea7d7b575ca51d"
  license "Apache-2.0"
  head "https://github.com/humio/cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cff544aa70eb05dffb3d1f844ddb8275c497b50945ed47ae6745ff63b074126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "859c91e94da2d80d42c2daf59c030b12879ecb8965ea6994312fa86c7b4acc18"
    sha256 cellar: :any_skip_relocation, ventura:       "4951f674c427df56691ab19b882e0d4df6c57a680711a1982d8a5744116e5709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75567f825ebd815a7ec0cf4eebc70d8fb2a6cecb323336f813e1c27f6f21365b"
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
