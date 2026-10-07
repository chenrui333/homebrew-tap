class Vimalender < Formula
  desc "Vim-style terminal calendar"
  homepage "https://github.com/Sadoaz/vimalender"
  url "https://github.com/Sadoaz/vimalender/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "9b9ded86eb07ae8220f2cb9b550a1e84a4b5368e2464ea1383625e7a06a719a8"
  license "MIT"
  head "https://github.com/Sadoaz/vimalender.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f90c7c937f6a8e518b0ba8016d659611f3f3f3cf78e620c92c78ab8659b5c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f90c7c937f6a8e518b0ba8016d659611f3f3f3cf78e620c92c78ab8659b5c02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94abe9de7d911efc7c60b90b83b5f80dcddcb20dcc109fc6a310bee10adb6f45"
    sha256 cellar: :any,                 x86_64_linux:  "e964b100f697a041d378f0e286c188434761d4b27cddf987dfc78d6aa19a9951"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
