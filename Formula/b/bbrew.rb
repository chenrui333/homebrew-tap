class Bbrew < Formula
  desc "Bold Brew (bbrew) - A Homebrew TUI Manager"
  homepage "https://bold-brew.com/"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6897d9eefd4355cb8160379138b7b96fbac9d647a51f3c43427fc3904e9b2dda"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1701e1bb7935784702eb6fec72b47714d5ce029fec6692a591a1da7651b0e94d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1701e1bb7935784702eb6fec72b47714d5ce029fec6692a591a1da7651b0e94d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1701e1bb7935784702eb6fec72b47714d5ce029fec6692a591a1da7651b0e94d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf6a74e5498b79c746575381d891bccedfd09525aff23049edbb0cac8363d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a51c5ae9566e834cfe9f2316e02ac0e6996ff26a1369dc9a5d769d1d6123e771"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X bbrew/internal/services.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bbrew"
  end

  test do
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
