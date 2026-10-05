class Matcha < Formula
  desc "Terminal email client built with Bubble Tea"
  homepage "https://matcha.email/"
  url "https://github.com/floatpane/matcha/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "8b20f7c92e48c5a5c5c8a5e4dbd8baa5152820124382f0547d583afe294b8fe9"
  license "MIT"
  head "https://github.com/floatpane/matcha.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3d4c2bd3e5b8837065a959e562c0bc6af2fdc6b6e44b1e061edbf449964d46f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d4c2bd3e5b8837065a959e562c0bc6af2fdc6b6e44b1e061edbf449964d46f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e134906149a8001cbfe60d3383c5c3e4a0de05d08be1e57317b10f73bf516f"
    sha256 cellar: :any,                 x86_64_linux:  "eaf6a8d1e94e05b3d7db65db9f9fdafdabb6f22dfc5ae54cef1647a3d30cf514"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
