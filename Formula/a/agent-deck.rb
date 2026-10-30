class AgentDeck < Formula
  desc "Terminal command center for AI coding agents"
  homepage "https://github.com/asheshgoplani/agent-deck"
  url "https://github.com/asheshgoplani/agent-deck/archive/refs/tags/v1.16.34.tar.gz"
  sha256 "0612943eb6a6c7d1484b2a599d56647b674988805f960627607e67735a012da6"
  license "MIT"
  head "https://github.com/asheshgoplani/agent-deck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8501df8160d06c4c765eb5ac5a184dacbae7a9a89e3ac07b75a3a3ceaeea92d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8501df8160d06c4c765eb5ac5a184dacbae7a9a89e3ac07b75a3a3ceaeea92d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c494498f34d41d099707a287ff9e3b0628ae00ba8304e06e20609a34333abb6e"
    sha256 cellar: :any,                 x86_64_linux:  "fd5bbd38887cbe03bf97ed6d705dfaa3b439a6e639549acd1329c1e8814fe923"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/agent-deck"
    generate_completions_from_executable(bin/"agent-deck", "completion")
  end

  service do
    run [opt_bin/"agent-deck", "web", "--no-tui", "--listen", "127.0.0.1:8420"]
    log_path var/"log/agent-deck.log"
    error_log_path var/"log/agent-deck.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-deck --version")

    system bin/"agent-deck", "profile", "create", "homebrew-test"
    assert_match "homebrew-test", shell_output("#{bin}/agent-deck profile list")
  end
end
