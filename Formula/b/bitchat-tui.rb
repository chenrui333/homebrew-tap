class BitchatTui < Formula
  desc "TUI client for bitchat"
  homepage "https://github.com/vaibhav-mattoo/bitchat-tui"
  url "https://github.com/vaibhav-mattoo/bitchat-tui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "626860df233f337ab204de3d64b04fc03aaeccbf9e8d692d53445d24cf5d6bcd"
  license "MIT"
  head "https://github.com/vaibhav-mattoo/bitchat-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea79669c124475143c6dcd0a20a59c20a22a48030e2a528661a320ebcd898e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543df0f7885d5653f506aeff1ba13b760778e9c02394a54c9efd56fe0d3b39e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a86a445de5b6312f1bbf57a568b909adc2c1a0ebac604471885ace22a93b329"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d884d0703879c68ff9e688e5abace1d7e5729d96598527ce2862ec1deeba57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e94acb92aa91d21d2d2696daf7790a956cb62a686d4881177a667165ef00107"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # failed with Linux CI, `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"bitchat-tui", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Public Chat", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
