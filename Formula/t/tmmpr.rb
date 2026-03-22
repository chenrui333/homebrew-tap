class Tmmpr < Formula
  desc "Terminal mind mapper"
  homepage "https://github.com/tanciaku/tmmpr"
  url "https://github.com/tanciaku/tmmpr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e15eb43872484147c2c9b54f618c8fb8a96d0d013e120d06e9d80a25ea0d42ec"
  license "MIT"
  head "https://github.com/tanciaku/tmmpr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"tmmpr.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"tmmpr", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"tmmpr", File::NULL, [:out, :err] => output_log.to_s
    end
    sleep 2
    Process.kill("TERM", pid) if Process.waitpid(pid, Process::WNOHANG).nil?
    Process.wait(pid)

    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  end
end
