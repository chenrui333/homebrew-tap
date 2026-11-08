class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "039147b220dd1ab40d2b07fd4a9a3589e4f667f6b5ec0c739e96544dd07fdc70"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "0f48fc525f655f8f22add07e4a2a8d72eb47209560d52eb16eeb7b9da40a1244"
    sha256 cellar: :any, x86_64_linux: "6215af2fe65651e912af661f5ad3f644a2b9658f25e515baae67c80856223716"
  end

  depends_on "rust" => :build
  depends_on :linux
  depends_on "passt"
  depends_on "qemu"
  depends_on "xorriso"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Honor the session runtime directory outside systemd-managed login sessions.
    # Upstream issue: https://github.com/pythops/kudu/issues/24
    inreplace "src/lib.rs",
              'PathBuf::from(format!("/run/user/{}/kudu", unsafe { USER_UID }))',
              <<~RUST.strip
                env::var_os("XDG_RUNTIME_DIR")
                    .map(PathBuf::from)
                    .unwrap_or_else(|| PathBuf::from(format!("/run/user/{}", unsafe { USER_UID })))
                    .join("kudu")
              RUST

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/kudu --version")
    ENV["TERM"] = "xterm"
    ENV["XDG_RUNTIME_DIR"] = testpath/"run"
    output = +""

    PTY.spawn("/bin/sh", "-c", "stty cols 120 rows 30; exec #{bin}/kudu") do |r, w, pid|
      Timeout.timeout(10) do
        begin
          until output.include?("KVM")
            output << r.readpartial(4096)
            # Crossterm needs a terminal response before drawing the dashboard.
            w.write "\e[1;1R" if output.sub!("\e[6n", "")
          end
        rescue EOFError, Errno::EIO
          flunk "Kudu exited before rendering its VM dashboard: #{output}"
        end
        w.write "q"
        begin
          loop { output << r.readpartial(4096) }
        rescue EOFError, Errno::EIO
          nil
        end
        _, status = Process.wait2(pid)
        pid = nil
        assert_predicate status, :success?
      end
    ensure
      if pid
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
    end

    assert_match "KVM", output
    assert_path_exists testpath/".local/share/kudu/vms"
    assert_path_exists testpath/"run/kudu"
  end
end
