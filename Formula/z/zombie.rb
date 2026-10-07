class Zombie < Formula
  desc "Terminal-based process manager with topology and controls"
  homepage "https://github.com/NVSRahul/zombie"
  url "https://github.com/NVSRahul/zombie/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "09c01801393358ae2991e42a33a60070fea02c4745ee4554dbdc34fad6deeebf"
  license "MIT"
  head "https://github.com/NVSRahul/zombie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d5fa167cc29a68e956cf02653892b8844e68900ad7ae227bb60c9f0be8e8fed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831172a4d474dd722472f0b64ef03247d1bd60a93d2bb1c461e99e06acbd13d8"
    sha256 cellar: :any,                 arm64_linux:   "4774461698af4968b9f8670ca62c85eff3028e0a23537265bd1bd79eb832271d"
    sha256 cellar: :any,                 x86_64_linux:  "f0e814adefa7b1ab6eed0a9768cea4bc2f1f9742d047b9074024593f094a2b60"
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
