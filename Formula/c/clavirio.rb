class Clavirio < Formula
  desc "Terminal typing tutor with lessons and session tracking"
  homepage "https://clavir.io"
  url "https://github.com/alexylon/clavirio/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "d673b7d6c20b3fb61b9d8037097383a7e544c021c1fd7467044eeb5da44ca5a5"
  license "Apache-2.0"
  head "https://github.com/alexylon/clavirio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1237fe6b3a78998a7fb59da0210ba24d46bad7610d1a0e90c034f1abb09dd1bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e10b72a98f5fa749901bd3cb7c29c356a9cec9916408f2966f46e48dbed2c09f"
    sha256 cellar: :any,                 arm64_linux:   "3b60f0d93c8dc5b421f1ebe9bd0e2c1dddeadbb8938b21e2f430520725648f1e"
    sha256 cellar: :any,                 x86_64_linux:  "0b18ff81ff6d17edfa1b66910d98bed0a42ff2729fbe03020be8159e7a3cdf1b"
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
