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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4fbe3016ddf7917d9f7f12c704bc966e19b4bcafd490b280983a4cf6e64bb2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4fbe3016ddf7917d9f7f12c704bc966e19b4bcafd490b280983a4cf6e64bb2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "791cddf98f87e35501afde5a433c0240cb6e382fea6de6fe8252866c499344b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c67285d4afd1fd31ae7ca43d4d7e08c559f7acd6f1bcb803c432f7b226e3ec4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
