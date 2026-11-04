class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "039147b220dd1ab40d2b07fd4a9a3589e4f667f6b5ec0c739e96544dd07fdc70"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "8731811ad17a0983db65a5d22b7388493a0a7b9bfca1aa633aeb4d6304b8da87"
    sha256 cellar: :any, x86_64_linux: "74ef32f4ab735b588d839dfb43761c60af23a64497690e9cd7990a6e054df894"
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
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/kudu --version")
    ENV["TERM"] = "xterm"
    output = +""

    PTY.spawn(bin/"kudu") do |r, w, pid|
      r.winsize = [30, 120]
      begin
        Timeout.timeout(10) do
          output << r.readpartial(4096) until output.include?("KVM")
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
    end

    assert_match "KVM", output
    assert_path_exists testpath/".local/share/kudu/vms"
  end
end
