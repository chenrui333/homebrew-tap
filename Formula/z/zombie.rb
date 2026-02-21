class Zombie < Formula
  desc "Terminal-based process manager with topology and controls"
  homepage "https://github.com/NVSRahul/zombie"
  url "https://github.com/NVSRahul/zombie/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "09c01801393358ae2991e42a33a60070fea02c4745ee4554dbdc34fad6deeebf"
  license "MIT"
  head "https://github.com/NVSRahul/zombie.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d4526c9b98b610c793dfb8e070eec90b4de9e922474c652d446a38d9f256b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "979fcb4bb71adf0cf72aae43e202c227763e78f1c28897dd8b7c60c55537f9ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8298f4f1245cc1a069e3a4ece27074bb9b14ef71b64d79485b16cad55d2672a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbbe675ea7edb39cd98ed50b913e14e95f39a89ad76cfcb2ec502baa205c89c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ced0ea9cf1405ee0e43b5c6623a007c681d40368c1b362ff553b0681cc1f6e31"
  end

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
