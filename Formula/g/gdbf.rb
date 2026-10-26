class Gdbf < Formula
  desc "Graphical frontend for GDB"
  homepage "https://github.com/greg7mdp/gdbf"
  url "https://github.com/greg7mdp/gdbf/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "6596f159e540928162e304ec963c75be3ca348ea142acc955ed37ee7566156af"
  license "MIT"
  head "https://github.com/greg7mdp/gdbf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a63413958313112d2544cbbac6bbb58be4e2b937eed50b239174c52e10c8835b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36a0603bf76fcc48134e5acfb5f12c37429a31587d5d6e0ecf4b65222c86988"
    sha256 cellar: :any,                 arm64_linux:   "b86ebeac5c02a953a6d36c69440bb19910abbb6e10a2ac62e79b9bcc0084218f"
    sha256 cellar: :any,                 x86_64_linux:  "ff868ecc1036307d5446bc298c6fbfe27ca3c9bec2e7ad6fbae27f7308304405"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "ctre" => :build
  depends_on "nlohmann-json" => :build
  depends_on "xorg-server" => :test
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdb"
  depends_on "libx11"

  # The test reaches Xvfb over TCP, as the macOS sandbox blocks its Unix socket
  allow_network_access! :test

  def install
    # Upstream tagged v0.8.3 without bumping the version header
    inreplace "src/gf.hpp", /GDBF_VERSION_PATCH \d+/, "GDBF_VERSION_PATCH #{version.patch}" if build.stable?
    # Link Homebrew's libX11 rather than XQuartz's
    inreplace "CMakeLists.txt", 'set(X11_ROOT "/opt/X11")', ""
    # Use Homebrew's fontconfig at runtime without requiring XQuartz.
    inreplace "src/luigi.cpp", "/opt/X11/bin/", "#{formula_opt_bin("fontconfig")}/" if OS.mac?
    # Use Homebrew's header-only libraries; the remaining doctest is only for upstream's tests
    rm_r %w[deps/include/boost deps/include/ctre.hpp deps/include/nlohmann]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "gdbf"
    bin.install "build/gdbf"
  end

  test do
    version_output = shell_output("#{bin}/gdbf --version", 1)
    if build.head?
      assert_match(/gdbf version \d+\.\d+\.\d+/, version_output)
    else
      assert_match version.to_s, version_output
    end

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
    output_log = testpath/"gdbf.log"
    gdbf_pid = spawn bin/"gdbf", "-ex", "shell touch #{marker}", [:out, :err] => output_log.to_s
    pids << gdbf_pid
    30.times do
      break if marker.exist?

      sleep 1
    end
    output = output_log.read
    assert_path_exists marker, output
  ensure
    # GDB runs in its own session and outlives gdbf, so kill gdbf's children while they are still listed
    if pids&.include?(gdbf_pid)
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
      begin
        Process.kill "TERM", pid
      rescue Errno::ESRCH
        nil
      end
      Process.wait pid
    end
  end
end
