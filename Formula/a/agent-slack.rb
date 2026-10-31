class AgentSlack < Formula
  desc "Slack automation CLI for AI agents"
  homepage "https://github.com/stablyai/agent-slack"
  url "https://github.com/stablyai/agent-slack/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "5d7b1b93d901ea28216d271315a5d9fbf68011d903c48a1d86cc87c31dacd7bf"
  license "MIT"
  head "https://github.com/stablyai/agent-slack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ad9fac7ddb552949147cd6a995b876c55006468ea1262224075019f67b701e49"
  end

  depends_on "bun"

  # Bun downloads the locked JavaScript dependencies before bundling the CLI.
  allow_network_access! :build

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "build", "src/index.ts", "--target=bun", "--outfile=dist/agent-slack.js",
                  "--define", "AGENT_SLACK_BUILD_VERSION=\"#{version}\""
    libexec.install "dist/agent-slack.js"
    (bin/"agent-slack").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/agent-slack.js" "$@"
    SH
    chmod 0755, bin/"agent-slack"
    pkgshare.install "skills" if (buildpath/"skills").directory?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-slack --version")
    credentials = testpath/".config/agent-slack/credentials.json"
    credentials.dirname.mkpath
    credentials.write JSON.generate(version: 1, workspaces: [])
    ENV["SLACK_TOKEN"] = "xoxc-homebrew-test"
    ENV.delete "SLACK_COOKIE_D"
    ENV.delete "SLACK_COOKIE"
    assert_match "SLACK_COOKIE_D is missing",
                 shell_output("#{bin}/agent-slack channel list 2>&1", 1)
  end
end
