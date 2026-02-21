class Zombie < Formula
  desc "Terminal-based process manager with topology and controls"
  homepage "https://github.com/NVSRahul/zombie"
  url "https://github.com/NVSRahul/zombie/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "09c01801393358ae2991e42a33a60070fea02c4745ee4554dbdc34fad6deeebf"
  license "MIT"
  head "https://github.com/NVSRahul/zombie.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    ENV["HOME"] = testpath

    history_path = if OS.mac?
      testpath/"Library/Application Support/com.zombie.cli/history.json"
    else
      testpath/".local/share/cli/history.json"
    end

    pid = fork do
      $stdout.reopen(File::NULL)
      $stderr.reopen(File::NULL)
      exec bin/"zombie"
    end

    20.times do
      break if history_path.exist?

      sleep 0.2
    end

    begin
      Process.kill("TERM", pid)
    rescue Errno::ESRCH
      nil
    end
    Process.wait(pid)

    assert_path_exists history_path
  end
end
