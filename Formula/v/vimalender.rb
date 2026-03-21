class Vimalender < Formula
  desc "Vim-style terminal calendar"
  homepage "https://github.com/Sadoaz/vimalender"
  url "https://github.com/Sadoaz/vimalender/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "9b9ded86eb07ae8220f2cb9b550a1e84a4b5368e2464ea1383625e7a06a719a8"
  license "MIT"
  head "https://github.com/Sadoaz/vimalender.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0027549504723d09cd62f89269c602a9ead92ddc26759b218b0fe2caf346f4af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0027549504723d09cd62f89269c602a9ead92ddc26759b218b0fe2caf346f4af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0027549504723d09cd62f89269c602a9ead92ddc26759b218b0fe2caf346f4af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2a9ea8a78e07a1dce707b5c80528efc7f5ec28f519afa01351652d7c09aca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55cc32ab758ffabee874dda60e87bcde5105120f9177abdf04f0aa0255495a0c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "pty"
    require "timeout"

    output = +""
    PTY.spawn({ "TERM" => "xterm-256color", "XDG_DATA_HOME" => testpath.to_s },
              "/bin/sh", "-c", "stty cols 120 rows 40; exec #{bin}/vimalender") do |r, _w, pid|
      Timeout.timeout(15) do
        loop do
          output << r.readpartial(1024)
          next unless output.include?("WEEK")

          Process.kill("TERM", pid)
          break
        end

        loop { output << r.readpartial(1024) }
      rescue EOFError, Errno::EIO
        nil
      end
    end

    assert_match "WEEK", output
  end
end
