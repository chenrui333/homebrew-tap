class Zombie < Formula
  desc "Terminal-based process manager with topology and controls"
  homepage "https://github.com/NVSRahul/zombie"
  url "https://github.com/NVSRahul/zombie/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "09c01801393358ae2991e42a33a60070fea02c4745ee4554dbdc34fad6deeebf"
  license "MIT"
  head "https://github.com/NVSRahul/zombie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06cb6a9f1f433133df492c899930df0512944c1136a2f0347006d9c7801334c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "512c4d0f1f00996ae60a7baa90854d251a018cce8b712e837b19753c38eaa47e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5811a17703eb315d3dbf2ed3c9903148f30ae566b739db23aad78922bb376af6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb09a0ad698afb5c7e7a7f352e90a1970ca6059a193433b0778fc2fa7b4f3914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cbd4ac9ed28b74d1b45f24116d79d2a8755b9c2c2bd2c7a126dc660bec045b5"
  end

  depends_on "rust" => :build

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
