class Mult < Formula
  desc "Run a command multiple times and glance at the outputs"
  homepage "https://github.com/dhth/mult"
  url "https://github.com/dhth/mult/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b8115600e51155a8b2f639c90a4f50c1a019b3551e80b9c9843a729fd711b453"
  license "MIT"
  head "https://github.com/dhth/mult.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Run a command multiple times", shell_output("#{bin}/mult --help")

    output = +""
    require "pty"

    PTY.spawn(bin/"mult", "-s", "-n", "2", "--", "sh", "-c", "printf 'hi\\n'") do |r, w, pid|
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

        break if output.include?("average time:")
      end

      w.write "q"
      w.close

      Timeout.timeout(5) do
        loop do
          output << r.read_nonblock(4096)
        rescue IO::WaitReadable
          r.wait_readable(0.2)
          retry
        rescue EOFError, Errno::EIO
          break
        end
      ensure
        Process.wait(pid)
      end
    end

    assert_match "2 runs", output
    assert_match "finished after", output
    assert_match "average time:", output
  end
end
