class Mcpd < Formula
  desc "Declaratively manage Model Context Protocol (MCP) servers"
  homepage "https://mozilla-ai.github.io/mcpd/"
  url "https://github.com/mozilla-ai/mcpd/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c06b129de66dabe715d3ac5fdf77a9cf4f06c53e54670b019b72f9f3589304b9"
  license "MIT"
  head "https://github.com/mozilla-ai/mcpd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c46f878ec2bd4c96e4129691272bdb79aac21835c69c18715b6af3c324546a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c46f878ec2bd4c96e4129691272bdb79aac21835c69c18715b6af3c324546a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c46f878ec2bd4c96e4129691272bdb79aac21835c69c18715b6af3c324546a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2531c7753a603aa7ab01737b52bdb1a8aaf6dcc0f57239d82ded2df8ccf93614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1630cc59c83fda55bd574c261fe190ad3bfa44205372b39438d6e73f95caaa2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.version=#{version}
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.commit=#{tap.user}
      -X github.com/mozilla-ai/mcpd/v2/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpd --version")

    system bin/"mcpd", "init"
    assert_match "servers = []", (testpath/".mcpd.toml").read
  end
end
