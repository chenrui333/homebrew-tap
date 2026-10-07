class Ugdb < Formula
  desc "TUI for gdb"
  homepage "https://github.com/ftilde/ugdb"
  url "https://github.com/ftilde/ugdb/archive/refs/tags/0.1.12.tar.gz"
  sha256 "f3bd6d36c930dcdcd4f80d03ee1883f8312f5de04e1240ba78e990a2bec58d72"
  license "MIT"
  head "https://github.com/ftilde/ugdb.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60ed0e0500840340f3eb787e79064a08ba7740104e41c0bdf47cba8034506f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e579080c04ed7e3fd10969e7206c57789fba8b0209b2aea99ed9b107457bf9e3"
    sha256 cellar: :any,                 arm64_linux:   "688f2cf2d64ff029358ea16425504ddf66f35649ecad39ae150ab05f4fbbef73"
    sha256 cellar: :any,                 x86_64_linux:  "0620bf70e77938033a5ad60af35848f4c5831e2478eb6031e3a58c4e4cea1faf"
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
