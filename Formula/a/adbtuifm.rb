class Adbtuifm < Formula
  desc "TUI File Manager for ADB"
  homepage "https://github.com/darkhz/adbtuifm"
  url "https://github.com/darkhz/adbtuifm/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "1483c1dbf1a7bbd610f27d7ad3039f4731ca456fa059b5f84d3bb532e79efc66"
  license "MIT"
  head "https://github.com/darkhz/adbtuifm.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"adbtuifm", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "adbtuifm: error: unexpected", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
