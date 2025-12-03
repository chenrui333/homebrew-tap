class Csvi < Formula
  desc "Cross-platform terminal CSV editor"
  homepage "https://hymkor.github.io/csvi/"
  url "https://github.com/hymkor/csvi/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "4fe68cdacba053923597d50a3682cc1f3270874f6231809ca78b0e6dbc1465ad"
  license "MIT"
  head "https://github.com/hymkor/csvi.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/csvi"
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"csvi", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "[TSV][EOF](1,1/1)", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
