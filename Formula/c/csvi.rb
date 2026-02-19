class Csvi < Formula
  desc "Cross-platform terminal CSV editor"
  homepage "https://hymkor.github.io/csvi/"
  url "https://github.com/hymkor/csvi/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "f3f5f852111070d5002f4152833d125cc395430a00587142b71536664623be93"
  license "MIT"
  head "https://github.com/hymkor/csvi.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/csvi"
  end

  test do
    output_log = testpath/"output.log"
    pattern = "[TSV][EOF](1,1/1)"
    pid = spawn bin/"csvi", [:out, :err] => output_log.to_s
    timeout = Time.now + 10

    until output_log.exist? && output_log.read.include?(pattern)
      raise "Timed out waiting for csvi output" if Time.now > timeout

      sleep 0.2
    end

    assert_match pattern, output_log.read
  ensure
    if Process.waitpid(pid, Process::WNOHANG).nil?
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
