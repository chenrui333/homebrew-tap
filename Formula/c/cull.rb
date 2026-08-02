class Cull < Formula
  desc "Interactive TUI disk space analyzer"
  homepage "https://github.com/legostin/cull"
  url "https://github.com/legostin/cull/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e928c1f27bf2820d7fb5406b8d17316bf7804f6327c790635314cdcf2fbf939d"
  license "MIT"
  head "https://github.com/legostin/cull.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09f458fb9f5db234ff7c689e1febfdcaaa3808aaa30a5df111f80d85114b8705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f458fb9f5db234ff7c689e1febfdcaaa3808aaa30a5df111f80d85114b8705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f458fb9f5db234ff7c689e1febfdcaaa3808aaa30a5df111f80d85114b8705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce8b25f60e38e0e17460fdb5cbb451f733bd21bf7ac3839f10493459dc552f6"
    sha256 cellar: :any,                 x86_64_linux:  "5568287dac990d102254a2f01d540862ece626fa464debff01a4c3f45c1c6cd6"
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
