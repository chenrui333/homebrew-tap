class Mult < Formula
  desc "Run a command multiple times and glance at the outputs"
  homepage "https://github.com/dhth/mult"
  url "https://github.com/dhth/mult/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b8115600e51155a8b2f639c90a4f50c1a019b3551e80b9c9843a729fd711b453"
  license "MIT"
  head "https://github.com/dhth/mult.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13a0b1a1b73dacb092e1ffc2a418d3871cc57b75763e83a547f9d7d17f9b6039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13a0b1a1b73dacb092e1ffc2a418d3871cc57b75763e83a547f9d7d17f9b6039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a0b1a1b73dacb092e1ffc2a418d3871cc57b75763e83a547f9d7d17f9b6039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dee538d1687fad7a4bebfa05b19ccc18d537f5a89f25a723412572a9c6701d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce9338ddeefb6d8b95ca39a12e76678108265c0dfd80a954e04da9c613d22c42"
  end

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
