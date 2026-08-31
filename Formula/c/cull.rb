class Cull < Formula
  desc "Interactive TUI disk space analyzer"
  homepage "https://github.com/legostin/cull"
  url "https://github.com/legostin/cull/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "49f21de1a3503fac2f929b0bc40e117fe64c3b46325deddbe9c1340c585690fe"
  license "MIT"
  head "https://github.com/legostin/cull.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fba9615d043ade95a1cec546fbc058f4b880fe30f9455644480ac81fb4e1c1e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fba9615d043ade95a1cec546fbc058f4b880fe30f9455644480ac81fb4e1c1e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba9615d043ade95a1cec546fbc058f4b880fe30f9455644480ac81fb4e1c1e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4ec9394d4ed1fed2bbb057e8049ffc9154e75601b697bf25979f73a20d9d172"
    sha256 cellar: :any,                 x86_64_linux:  "be569ddb297786a5fd05ca786d16d7fb44437f5ff8583aa29293333a9eef537a"
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
