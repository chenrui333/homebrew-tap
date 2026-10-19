class Gf2 < Formula
  desc "Graphical frontend for GDB"
  homepage "https://github.com/nakst/gf"
  url "https://github.com/nakst/gf/archive/1c04ed95d45d49fb4b06cbc620c61acd58818977.tar.gz"
  version "0.0.1"
  sha256 "d14ce7a6ca530407ba25333345a9c472de42d410cbae9424530e025b859ac384"
  license "MIT"
  head "https://github.com/nakst/gf.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "f14428165a4d2a4ba7ec4ffd2bbde9408a71b2215ca910c12addac025fe2d2cf"
    sha256 cellar: :any, x86_64_linux: "49b6b991f3ac24a803bf6cef801de843fb0fb8b9835067a487f1cc41ff2cd43e"
  end

  depends_on "xorg-server" => :test
  depends_on "freetype"
  depends_on "gdb"
  depends_on "libx11"
  depends_on :linux

  deny_network_access!

  def install
    args = %W[-O2 -pthread -DUI_FREETYPE -I#{formula_opt_include("freetype")}/freetype2]
    args << "-DUI_SSE2" if Hardware::CPU.intel?
    system ENV.cxx, "gf2.cpp", "-o", "gf2", *args, "-lX11", "-lfreetype"
    bin.install "gf2"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    pids = []
    # Not using xvfb-run, which can leave processes running after the test
    IO.pipe do |read_io, write_io|
      pids << spawn(formula_opt_bin("xorg-server")/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
      write_io.close
      ENV["DISPLAY"] = ":#{read_io.read.strip}"
    end

    # gf2 forwards its arguments to GDB, which it only starts after opening its window
    marker = testpath/"gdb-ran"
    gf2_pid = spawn bin/"gf2", "-ex", "shell touch #{marker}"
    pids << gf2_pid
    30.times do
      break if marker.exist?

      sleep 1
    end
    assert_path_exists marker

    # gf2 shuts GDB down and exits cleanly on SIGINT
    Process.kill "INT", gf2_pid
    _, status = Process.wait2 gf2_pid
    pids.delete gf2_pid
    assert_predicate status, :success?
  ensure
    # GDB runs in its own session and outlives gf2, so kill gf2's children while they are still listed
    if gf2_pid
      Dir["/proc/#{gf2_pid}/task/*/children"].flat_map { |path| File.read(path).split }.each do |pid|
        Process.kill "KILL", pid.to_i
      rescue Errno::ESRCH
        nil
      end
    end
    pids&.reverse_each do |pid|
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
