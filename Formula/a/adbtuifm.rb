class Adbtuifm < Formula
  desc "TUI File Manager for ADB"
  homepage "https://github.com/darkhz/adbtuifm"
  url "https://github.com/darkhz/adbtuifm/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "1483c1dbf1a7bbd610f27d7ad3039f4731ca456fa059b5f84d3bb532e79efc66"
  license "MIT"
  head "https://github.com/darkhz/adbtuifm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba495be52869769df731a9869a941657bc9f5ca937b392648905c5abbe9af81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3c5a6211667d84228832ec7e008799ebfd7181dac427425e809a234f841f34d"
    sha256 cellar: :any_skip_relocation, ventura:       "e5eb118922e2a01e743d288a42e482e480da1bdfda497392b3978d25109cd52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8084e18b4b741e531dd44b55b815e0e957673a2ad266e72c411ca590c44be6cc"
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
