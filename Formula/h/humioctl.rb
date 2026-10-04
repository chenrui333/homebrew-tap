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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d397c65e438e086c47342e36d96c5cc7b10b7549c19e078cc4bfcee44f1c276"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d397c65e438e086c47342e36d96c5cc7b10b7549c19e078cc4bfcee44f1c276"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d397c65e438e086c47342e36d96c5cc7b10b7549c19e078cc4bfcee44f1c276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b40fdd3785b6282c2974bc7e2c07cd2cc757b4f50658fa296ed6fc5753d5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1701c34f2946046cfcd78fe882ec5f272f03d4934d7586a37c111e7576e8651a"
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
