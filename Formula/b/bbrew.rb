class Bbrew < Formula
  desc "Bold Brew (bbrew) - A Homebrew TUI Manager"
  homepage "https://bold-brew.com/"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "2e22f351e9726128746a3f2f8591e9d1a2f525cbe1aca6b0af6a20f6f909faec"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59ec7bd1b840f31717f1043eb81fe30f7391c3421c776878330af1982a30614a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59ec7bd1b840f31717f1043eb81fe30f7391c3421c776878330af1982a30614a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59ec7bd1b840f31717f1043eb81fe30f7391c3421c776878330af1982a30614a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb84f589a9ef13f405973f6f6dfbd97f1c2b7cd772ba005bc92ae5ffd5410948"
    sha256 cellar: :any,                 x86_64_linux:  "16677b18498e4a2fa8c5af1ad5561a9f0bab23971e94df7cd711e65cb8e1d463"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X bbrew/internal/services.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bbrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bbrew --version")

    (testpath/"Brewfile").write <<~EOS
      brew "wget"
    EOS

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"bbrew", "-f", testpath/"Brewfile", [:out, :err] => output_log.to_s
      sleep 8
      assert_match "Application error: terminal not cursor addressable", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
