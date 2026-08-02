class Cull < Formula
  desc "Interactive TUI disk space analyzer"
  homepage "https://github.com/legostin/cull"
  url "https://github.com/legostin/cull/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e928c1f27bf2820d7fb5406b8d17316bf7804f6327c790635314cdcf2fbf939d"
  license "MIT"
  head "https://github.com/legostin/cull.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b904948635e6bcb37d624d61ad5766cc6f7866de8dfd95fc6f53b056d8526331"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b904948635e6bcb37d624d61ad5766cc6f7866de8dfd95fc6f53b056d8526331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b904948635e6bcb37d624d61ad5766cc6f7866de8dfd95fc6f53b056d8526331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0f4f871f1417202840d9bc35ec6cec120d878f8af2d286ef95078cdaa5a718"
    sha256 cellar: :any,                 x86_64_linux:  "b81c33f5f028db52474529f3e0e2a200e4a021c1637d77e003c50d2d7a076448"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"cull"), "."
  end

  test do
    require "pty"
    require "timeout"

    (testpath/"sample.txt").write("homebrew\n")
    output = +""

    PTY.spawn(bin/"cull", "--read-only", testpath.to_s) do |r, w, pid|
      deadline = Time.now + 5
      while Time.now < deadline
        next unless r.wait_readable(0.2)

        begin
          output << r.read_nonblock(4096)
        rescue IO::WaitReadable
          next
        rescue EOFError, Errno::EIO
          break
        end

        break if output.include?("\e[?1049h")
      end

      w.write "q"

      begin
        Timeout.timeout(5) do
          loop do
            output << r.read_nonblock(4096)
          rescue IO::WaitReadable
            sleep 0.1
          rescue EOFError, Errno::EIO
            break
          end
          Process.wait(pid)
        end
      rescue Timeout::Error
        Process.kill("TERM", pid)
        Process.wait(pid)
        raise "cull test timed out waiting for quit"
      end

      assert_match "\e[?1049h", output
      assert_equal 0, $CHILD_STATUS.exitstatus
    end

    assert_path_exists testpath/"sample.txt"
  end
end
