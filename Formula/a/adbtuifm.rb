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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45e4ee75df4fd3eaad37e1b9efef474e11c0c6d3e66ff582212da6fb3761ce30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e4ee75df4fd3eaad37e1b9efef474e11c0c6d3e66ff582212da6fb3761ce30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e4ee75df4fd3eaad37e1b9efef474e11c0c6d3e66ff582212da6fb3761ce30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a72cfad8603ec0bba4c2dfea775c8cfd15330d32bac3b9e0f1ca6cf139fc1000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa1de2bea0c4f2309f4ffae15a96e14f6f82855f1e50cbcf580c3ae14d4e29a"
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
