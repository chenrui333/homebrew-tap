class Humioctl < Formula
  desc "CLI Client for Humio - Stream Logs All Day Long"
  homepage "https://www.crowdstrike.com/platform/next-gen-siem/falcon-logscale/"
  url "https://github.com/humio/cli/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "d59bbb35b005cd1b606b87f458ba9b2ed4ef55113ed273e6c7ea7d7b575ca51d"
  license "Apache-2.0"
  head "https://github.com/humio/cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27419a605de9c23e42739950058bc499b49cd74e50fd41ef6f21bbacda100919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27419a605de9c23e42739950058bc499b49cd74e50fd41ef6f21bbacda100919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27419a605de9c23e42739950058bc499b49cd74e50fd41ef6f21bbacda100919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe42ce71a13da0228bda3042d2aeb1185720ba8df21c30c710e95157b30f1fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671e1195dffdd12ac3656237a049c4ba0d3746523dc11604ae1a3e196a27224c"
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
