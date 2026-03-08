class Cull < Formula
  desc "Interactive TUI disk space analyzer"
  homepage "https://github.com/legostin/cull"
  url "https://github.com/legostin/cull/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d0c74e027aca172e55281a58492e78ced4cfdc896a89ba501a0d9e7ea54ee948"
  license "MIT"
  revision 1
  head "https://github.com/legostin/cull.git", branch: "main"

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
