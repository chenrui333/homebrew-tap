class Gdbf < Formula
  desc "Graphical frontend for GDB"
  homepage "https://github.com/greg7mdp/gdbf"
  url "https://github.com/greg7mdp/gdbf/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "6596f159e540928162e304ec963c75be3ca348ea142acc955ed37ee7566156af"
  license "MIT"
  head "https://github.com/greg7mdp/gdbf.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "xorg-server" => :test
  depends_on "freetype"
  depends_on "gdb"
  depends_on "libx11"

  # The test reaches Xvfb over TCP, as the macOS sandbox blocks its Unix socket
  allow_network_access! :test

  def install
    # Upstream tagged v0.8.3 without bumping the version header
    inreplace "src/gf.hpp", /GDBF_VERSION_PATCH \d+/, "GDBF_VERSION_PATCH #{version.patch}"
    # Link Homebrew's libX11 rather than XQuartz's
    inreplace "CMakeLists.txt", 'set(X11_ROOT "/opt/X11")', ""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "gdbf"
    bin.install "build/gdbf"
  end

  test do
    assert_match "gdbf version #{version}", shell_output("#{bin}/gdbf --version", 1)

    pids = []
    # Not using xvfb-run, which can leave processes running after the test
    IO.pipe do |read_io, write_io|
      pids << spawn(formula_opt_bin("xorg-server")/"Xvfb", "-displayfd", write_io.fileno.to_s, "-listen", "tcp",
                    write_io => write_io)
      write_io.close
      ENV["DISPLAY"] = ":#{read_io.read.strip}"
    end

    # gdbf forwards its arguments to GDB, which it only starts after opening its window
    marker = testpath/"gdb-ran"
    gdbf_pid = spawn bin/"gdbf", "-ex", "shell touch #{marker}"
    pids << gdbf_pid
    30.times do
      break if marker.exist?

      sleep 1
    end
    assert_path_exists marker

    # gdbf shuts GDB down and exits cleanly on SIGINT
    Process.kill "INT", gdbf_pid
    _, status = Process.wait2 gdbf_pid
    pids.delete gdbf_pid
    assert_predicate status, :success?
  ensure
    # GDB runs in its own session and outlives gdbf, so kill gdbf's children while they are still listed
    if gdbf_pid
      child_pids = if OS.mac?
        Utils.popen_read("pgrep", "-P", gdbf_pid.to_s).split
      else
        Dir["/proc/#{gdbf_pid}/task/*/children"].flat_map { |path| File.read(path).split }
      end
      child_pids.each do |pid|
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
