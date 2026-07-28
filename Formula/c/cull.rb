class Cull < Formula
  desc "Interactive TUI disk space analyzer"
  homepage "https://github.com/legostin/cull"
  url "https://github.com/legostin/cull/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "55b03cdd488d1ace8feee2bbef46d09b695791a81f95670c2b200d38b2c9a730"
  license "MIT"
  head "https://github.com/legostin/cull.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02c7f8f558fdf228647689c09e5e4ba8a47c3ee86151b6f338c33517ef995fc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02c7f8f558fdf228647689c09e5e4ba8a47c3ee86151b6f338c33517ef995fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02c7f8f558fdf228647689c09e5e4ba8a47c3ee86151b6f338c33517ef995fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0f29bf46b5556f7d81a23f54db9fc915e837c93d2e1a09afcce8281f736de15"
    sha256 cellar: :any,                 x86_64_linux:  "8f5c9cf4e08981d48d90a4828df615e136232b53f00db6cf8a543586b57820ae"
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
