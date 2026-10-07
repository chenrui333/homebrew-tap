class Wakey < Formula
  desc "TUI built for managing and waking your devices using Wake-on-LAN"
  homepage "https://github.com/jonathanruiz/wakey"
  url "https://github.com/jonathanruiz/wakey/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "20480d3132f75a2b6af8cfd2990921ee363965e649de9ae3d5c5464dadba635f"
  license "MIT"
  head "https://github.com/jonathanruiz/wakey.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b796de79e9b3317c79d8e0bb22741b7d672816f86573bdb31f29cb2a1bfbbabe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b796de79e9b3317c79d8e0bb22741b7d672816f86573bdb31f29cb2a1bfbbabe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0adaa8ffbe87a0ab13bebb0f4e1e8f88fc9aeb95a72c97fdda8e0663367019c"
    sha256 cellar: :any,                 x86_64_linux:  "2fab327230fa0ee44ea86dd029eb8861dcf31b6c1404a0235f767fe58d1adeed"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
