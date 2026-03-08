class Pproftui < Formula
  desc "TUI for Go pprof data"
  homepage "https://github.com/Oloruntobi1/pproftui"
  url "https://github.com/Oloruntobi1/pproftui/archive/d94a02c55dcdfc0bd2617acc9a1b98079bf990d8.tar.gz"
  version "0.0.1"
  sha256 "1538131099b317c33c7b0864aee888dd2c8af18e330734a751d3b22d0c81c379"
  license "MIT"
  head "https://github.com/Oloruntobi1/pproftui.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Usage of", shell_output("#{bin}/pproftui -h 2>&1")

    resource "test_profile" do
      url "https://github.com/parca-dev/parca/raw/refs/heads/main/pkg/symbolizer/testdata/normal-cpu.stripped.pprof"
      sha256 "6e6087cf6a592f40a669aa7f96c38a2220cf5fc4006d6f89848666a859dad39b"
    end

    testpath.install resource("test_profile")

    output_log = testpath/"output.log"
    pid = spawn bin/"pproftui", testpath/"normal-cpu.stripped.pprof", [:out, :err] => output_log.to_s

    timeout = Time.now + 10
    until output_log.exist? && output_log.read.include?("Initializing...")
      break if Time.now > timeout

      sleep 0.2
    end

    assert_match "Initializing...", output_log.read
  ensure
    if pid && Process.waitpid(pid, Process::WNOHANG).nil?
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
