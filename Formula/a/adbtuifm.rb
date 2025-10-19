class Adbtuifm < Formula
  desc "TUI File Manager for ADB"
  homepage "https://github.com/darkhz/adbtuifm"
  url "https://github.com/darkhz/adbtuifm/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "1483c1dbf1a7bbd610f27d7ad3039f4731ca456fa059b5f84d3bb532e79efc66"
  license "MIT"
  revision 1
  head "https://github.com/darkhz/adbtuifm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34db19f48a06c4f274b02926cc25ac68d93658200ec190242d1398f75d5063c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34db19f48a06c4f274b02926cc25ac68d93658200ec190242d1398f75d5063c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34db19f48a06c4f274b02926cc25ac68d93658200ec190242d1398f75d5063c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bbd220b67545fd975f2c378993ac2c040c4e6a81ccc2c3eb1462697de05d6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729c394611325b75c7c4dd14c34d6c400e5634644ec00492f61c9f5bf94338d1"
  end

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
