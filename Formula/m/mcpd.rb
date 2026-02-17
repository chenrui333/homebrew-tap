class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c99c9d02799782a2dd7a9b2082c805f363a1a75535fffed05743ce33e19491c9"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de70290730eec044ffce93a849fc74b263c612b37fa94a4ad7c3db9418f52590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de70290730eec044ffce93a849fc74b263c612b37fa94a4ad7c3db9418f52590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de70290730eec044ffce93a849fc74b263c612b37fa94a4ad7c3db9418f52590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55afa7e8ecb8e5de1f4d4c3474f2a2ff04f06d1112f88c2e765a809d0e5dd7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eca73009a8c1f03b4ba04ef783e77007f2af058d719940a692e24b1bdc75377"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mozilla-ai/mcpd/internal/cmd.version=#{version}
      -X github.com/mozilla-ai/mcpd/internal/cmd.commit=#{tap.user}
      -X github.com/mozilla-ai/mcpd/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpd --version")

    system bin/"mcpd", "init"
    assert_match "servers = []", (testpath/".mcpd.toml").read
  end
end
