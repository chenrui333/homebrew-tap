class AgentDeck < Formula
  desc "Terminal command center for AI coding agents"
  homepage "https://github.com/asheshgoplani/agent-deck"
  url "https://github.com/asheshgoplani/agent-deck/archive/refs/tags/v1.16.40.tar.gz"
  sha256 "31520fdfa6752a2835bbff0e965d9c1458bf523d7492d7815d6f974f40149bc0"
  license "MIT"
  head "https://github.com/asheshgoplani/agent-deck.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "38a64e369efd0b737e12b49fd20420bfe4ff3c9eb1d0dbebfb5ead2970d72fa3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c98ebc7290411e4dfa0a7d082022bc20b101327f7384dce7887e99da42ffabc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c98ebc7290411e4dfa0a7d082022bc20b101327f7384dce7887e99da42ffabc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "610e815208e055398264b95dce07402badcadb1bbe53f114c2c4c2316daacd63"
    sha256 cellar: :any,                 x86_64_linux:  "d32bb709e3164cb6b5ca98fbe6e0d229c752e661e56dbc0c18d963ad5bba68fd"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/agent-deck"
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
