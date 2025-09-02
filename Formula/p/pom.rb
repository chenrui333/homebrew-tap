class Pom < Formula
  desc "Pomodoro timer in your terminal"
  homepage "https://github.com/maaslalani/pom"
  url "https://github.com/maaslalani/pom/archive/699204a6db4f942ee6a6bf0dc389709ab6e1663f.tar.gz"
  version "0.1.0"
  sha256 "2d661be063d1f8e770d26162bfa3d8d74d019a0e936dd91b652dcd4f9b9c8d87"
  license "MIT"
  head "https://github.com/maaslalani/pom.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"pom", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Focus Time\n1. 25 minutes\n2. 30 minutes\n3. 45 minutes\n4. 1 hour", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
