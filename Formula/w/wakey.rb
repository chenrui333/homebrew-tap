class Wakey < Formula
  desc "TUI built for managing and waking your devices using Wake-on-LAN"
  homepage "https://github.com/jonathanruiz/wakey"
  url "https://github.com/jonathanruiz/wakey/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "20480d3132f75a2b6af8cfd2990921ee363965e649de9ae3d5c5464dadba635f"
  license "MIT"
  head "https://github.com/jonathanruiz/wakey.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "046e82b2d703b67f20b0a306961194852c2133f11bd7bc5394f8b40bda3da9f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046e82b2d703b67f20b0a306961194852c2133f11bd7bc5394f8b40bda3da9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046e82b2d703b67f20b0a306961194852c2133f11bd7bc5394f8b40bda3da9f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4bfd4fe8d5af969e2c72edf6443836ab6403a85f71a45ab88d3cb75e679f3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f70819e29008e280810ee1121b67bcd5be9ae070860508eac3778260234ee578"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"wakey", [:out, :err] => output_log.to_s
    sleep 1
    assert_path_exists testpath/".wakey.db"
    assert_operator (testpath/".wakey.db").size, :>, 0
  ensure
    if pid
      begin
        Process.kill("TERM", pid)
        Process.wait(pid)
      rescue Errno::ECHILD, Errno::ESRCH
        nil
      end
    end
  end
end
