class Humioctl < Formula
  desc "CLI Client for Humio - Stream Logs All Day Long"
  homepage "https://www.crowdstrike.com/platform/next-gen-siem/falcon-logscale/"
  url "https://github.com/humio/cli/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "e588092e47d9943a1823e0af707c798945924957eff834b7d7b041ebcf712bc8"
  license "Apache-2.0"
  head "https://github.com/humio/cli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96a948708a0291bb8267177d22757576098c519455ad89a24107fa62d516c329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faefdc17181858ccf4ffbdf9cfc5bfe80b1540665a73323908b434fd6fd1582d"
    sha256 cellar: :any_skip_relocation, ventura:       "cdce80c291a0db2a6f9312fa26059184ec10554f6d64cf1ffd839361b8c312d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d966496637b66b19a98eaa8831d60d825410ee8c04bdad78f688ca59c2b11f"
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
