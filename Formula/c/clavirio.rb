class Clavirio < Formula
  desc "Terminal typing tutor with lessons and session tracking"
  homepage "https://clavir.io"
  url "https://github.com/alexylon/clavirio/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2a324c4b81b9824b021a38180dd8e3060b52740143c9fc6dc199f9e06b9c8473"
  license "Apache-2.0"
  head "https://github.com/alexylon/clavirio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4f413b02b83490e61627fb916f6998f6a93a7c02517f891f4434c5a33cd2d028"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7fedb3ec9c2bd4b35de3a9e77f5d0981727317ee24902b3e84896c3f484d21e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee4a90b75556ee2e9b8a41908f9ffdb0d05f761438a6eb212c94ad2fd6a56fcb"
    sha256 cellar: :any,                 arm64_linux:   "1ab309161fecb888cc3d7978ffcb64c8525d264ee63f9001f80e594832c1348c"
    sha256 cellar: :any,                 x86_64_linux:  "817572c4881e8a81cc25e54ad8bd8ff6e02c26dbb675ed9777890e0a1ce15df1"
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
