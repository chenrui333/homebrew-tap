class Ugdb < Formula
  desc "TUI for gdb"
  homepage "https://github.com/ftilde/ugdb"
  url "https://github.com/ftilde/ugdb/archive/refs/tags/0.1.12.tar.gz"
  sha256 "f3bd6d36c930dcdcd4f80d03ee1883f8312f5de04e1240ba78e990a2bec58d72"
  license "MIT"
  head "https://github.com/ftilde/ugdb.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be2c8c5e99ea1e1dd5a09bf127d74e2a660582dce2f598b20bb5192871793e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9597685eb95f3cb30348729cb159b20c56f575b6f7a6acd16a56c6779d2cafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2004e6594f128b0a9ee108ed6e6af1fa492f2ac6b4b7679063aba44e344ad8d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54683faa00286efb96250d170fe299eac10d543781dbbac1abcbd408d912915d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "def31c405c6e039c10baad4cf46c4b3b00ee98d8f1446a9acb85a8483850fb15"
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

    # ugdb calls tcgetattr on stdin before parsing CLI args, so even `--version`
    # needs a TTY (no TTY: `Failed to get terminal attributes: Sys(ENODEV)`).
    run_in_pty = lambda do |cmd|
      output = +""
      status = nil
      Timeout.timeout(30) do
        PTY.spawn("stty cols 120 rows 40; exec #{cmd}") do |r, _w, pid|
          begin
            r.each_line { |line| output << line }
          rescue Errno::EIO
            # PTY closed after the process exited
          end
          Process.wait(pid)
          status = $CHILD_STATUS.exitstatus
        end
      end
      [output, status]
    end

    # The IPC socket is `$XDG_RUNTIME_DIR/ugdb/<64 chars>`: the sandbox only allows
    # Unix sockets under its short TMPDIR, and macOS caps socket paths at 104 bytes.
    ENV["XDG_RUNTIME_DIR"] = ENV.fetch("TMPDIR", "/tmp")

    output, status = run_in_pty.call("#{bin}/ugdb --version")
    assert_match "ugdb #{version}", output
    assert_equal 0, status

    output, status = run_in_pty.call("#{bin}/ugdb --log_dir #{testpath} --gdb #{testpath}/missing-gdb 2>&1")
    assert_match "Failed to spawn gdb process", output
    assert_equal 252, status
  end
end
