class Clavirio < Formula
  desc "Terminal typing tutor with lessons and session tracking"
  homepage "https://clavir.io"
  url "https://github.com/alexylon/clavirio/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "fcbc367cc2c05973b1886db518a4cf9eb0f4d81e873fb8ccba0ae342532824c5"
  license "Apache-2.0"
  head "https://github.com/alexylon/clavirio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4611c3e842ddecdd08746c0c306456266e6774a9fd9e6b4a744853cdaba2c55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "184a7286e24492c72d22e4565e36a327e65aa7e02f9ffb855f7775f1c4a609bb"
    sha256 cellar: :any,                 arm64_linux:   "0b6526116934536e1f89ead243092d2d208e977ab2e78ad6c8b596e8039eadc7"
    sha256 cellar: :any,                 x86_64_linux:  "3aa6fa56b9ef2cc326bbf0be9759093095acc215011d2567aef33e58f6423480"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "timeout"

    assert_match version.to_s, shell_output("#{bin}/clavirio --version")
    (testpath/"homebrew-lesson.txt").write("homebrew typing practice\n")
    output = +""
    PTY.spawn({ "TERM" => "xterm-256color" }, "/bin/sh", "-c",
              "stty cols 120 rows 40; exec #{bin}/clavirio --file homebrew-lesson.txt") do |reader, writer, pid|
      Timeout.timeout(15) do
        loop do
          output << reader.readpartial(4096)
          next unless output.include?("homebrew-lesson.txt")

          writer.write "\u0003"
          break
        end
        loop { output << reader.readpartial(4096) }
      end
    rescue EOFError, Errno::EIO
      nil
    ensure
      begin
        Process.kill("KILL", pid)
      rescue Errno::ESRCH
        nil
      end
      begin
        Process.wait(pid)
      rescue Errno::ECHILD
        nil
      end
    end
    assert_match "homebrew-lesson.txt", output
  end
end
