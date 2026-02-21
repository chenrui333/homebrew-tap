class Matcha < Formula
  desc "Terminal email client built with Bubble Tea"
  homepage "https://matcha.floatpane.com/"
  url "https://github.com/floatpane/matcha/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "8b20f7c92e48c5a5c5c8a5e4dbd8baa5152820124382f0547d583afe294b8fe9"
  license "MIT"
  head "https://github.com/floatpane/matcha.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output_file = testpath/"matcha-test.log"
    pid = fork do
      Process.setsid
      $stdin.reopen(File::NULL)
      $stdout.reopen(output_file, "w")
      $stderr.reopen(output_file, "a")
      exec bin/"matcha"
    end
    Process.wait(pid)

    output = output_file.read
    assert_match "Alas, there's been an error", output
    assert_match "/dev/tty", output
  end
end
