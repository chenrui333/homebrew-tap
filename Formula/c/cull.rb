class Cull < Formula
  desc "Interactive TUI disk space analyzer"
  homepage "https://github.com/legostin/cull"
  url "https://github.com/legostin/cull/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d0c74e027aca172e55281a58492e78ced4cfdc896a89ba501a0d9e7ea54ee948"
  license "MIT"
  revision 1
  head "https://github.com/legostin/cull.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cdfc5f1e2cbb51c46db96c8a4a6ba9daf61e4b43d6c545ff97b63cf6f0bcc87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cdfc5f1e2cbb51c46db96c8a4a6ba9daf61e4b43d6c545ff97b63cf6f0bcc87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cdfc5f1e2cbb51c46db96c8a4a6ba9daf61e4b43d6c545ff97b63cf6f0bcc87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2716caa08dc8689679c1b4bee1f64cfa6a75ffbe8180783b8d1046c2a8568b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad8d679f511d833223fcee4e3be01f2ac92742271d45989991aab8cda718943"
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
