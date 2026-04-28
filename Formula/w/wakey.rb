class Wakey < Formula
  desc "TUI built for managing and waking your devices using Wake-on-LAN"
  homepage "https://github.com/jonathanruiz/wakey"
  url "https://github.com/jonathanruiz/wakey/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "29a58792be3334063bf8b2f5b48f9193a5d308b41a7e7f3b2a704d0bb05aa53d"
  license "MIT"
  head "https://github.com/jonathanruiz/wakey.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e1559874e2ca5862cafa2177f623b89867df2735408486d3552c91479c94bca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1559874e2ca5862cafa2177f623b89867df2735408486d3552c91479c94bca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e1559874e2ca5862cafa2177f623b89867df2735408486d3552c91479c94bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2382f01cf4fb79aa99658bf20c64ecbb03b92c923f169562aedf6e1660f9b836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e6650d2e84c102bec787ce43112b736a941d285682019b04d62420889e4218a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"wakey", [:out, :err] => output_log.to_s
    sleep 1
    assert_match '"devices": []', (testpath/".wakey_config.json").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
