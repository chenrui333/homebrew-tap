class Clavirio < Formula
  desc "Terminal typing tutor with lessons and session tracking"
  homepage "https://clavir.io"
  url "https://github.com/alexylon/clavirio/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "fcbc367cc2c05973b1886db518a4cf9eb0f4d81e873fb8ccba0ae342532824c5"
  license "Apache-2.0"
  head "https://github.com/alexylon/clavirio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a68804f4401c9741b6a6124e09a720679f10e5c4286991dc1a6e55bc06b19e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e793518a319e7e5267c1e2bf814f416eed58f10e097ecafcd3c34b10989838b"
    sha256 cellar: :any,                 arm64_linux:   "0fa140e93d864229b65574f2bcad47030d3d8503f6d10ae6ab78875a85e92e12"
    sha256 cellar: :any,                 x86_64_linux:  "f46dfe2f00877dbc94ed8acb866f9dc8a4f0b2e2aa4bb9082372f3bed39c58fc"
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
