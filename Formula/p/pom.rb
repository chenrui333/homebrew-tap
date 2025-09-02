class Pom < Formula
  desc "Pomodoro timer in your terminal"
  homepage "https://github.com/maaslalani/pom"
  url "https://github.com/maaslalani/pom/archive/699204a6db4f942ee6a6bf0dc389709ab6e1663f.tar.gz"
  version "0.1.0"
  sha256 "2d661be063d1f8e770d26162bfa3d8d74d019a0e936dd91b652dcd4f9b9c8d87"
  license "MIT"
  head "https://github.com/maaslalani/pom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "253c0ea5df371ceab92804641d7c79d2cb94cce5f37611a948ee91b4ac22a54b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f35fb99a5f07c09d785846488101dcdc6a16f9834fe14913e565739ec162f6"
    sha256 cellar: :any_skip_relocation, ventura:       "d5657acb0c1f76959a125ac01819c2c5d6e3cb41921162836f17f979b2b6b479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f789927c62a6e3e38ec0f7522f79a931ecfcb34e9fcf4ad31657ce1b264fbd3"
  end

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
