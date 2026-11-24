class Clavirio < Formula
  desc "Terminal typing tutor with lessons and session tracking"
  homepage "https://clavir.io"
  url "https://github.com/alexylon/clavirio/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "35cdb66dd5e649cdae79bed997785b070d861e757d048adb0fbdb8b57a837a55"
  license "Apache-2.0"
  head "https://github.com/alexylon/clavirio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "024e99cd43f9c1859b0050561c2d0b284cf2575a69df2ecd300b8251b962f57e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55916450404b8fd628ce248694c366e703f500aa9556ca70a9cfc1efa9478f2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "982688fd3fb76ecc1ecdbd335d24fe432322abdfc8f0c7ec1bfacd1001ecd798"
    sha256 cellar: :any,                 arm64_linux:   "5baaffab8a14e149b4adcb7625068b5b5231b36c8d1b43e5296096549c8c69f5"
    sha256 cellar: :any,                 x86_64_linux:  "772c6b6eebd3bed5059ca8f1f04cc6274fc6f2b90c924d3733ff1f91e3653e70"
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
