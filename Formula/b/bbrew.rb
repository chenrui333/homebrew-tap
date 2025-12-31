class Bbrew < Formula
  desc "Bold Brew (bbrew) - A Homebrew TUI Manager"
  homepage "https://bold-brew.com/"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "ec424e255ee90cdb2ee425f08898fba8587b145d8398f96cba63eec7b21f40ed"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4be7ef4856626386211ee24973fba5a137bcc18a09037c9df1f6cbbcfac7820c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be7ef4856626386211ee24973fba5a137bcc18a09037c9df1f6cbbcfac7820c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be7ef4856626386211ee24973fba5a137bcc18a09037c9df1f6cbbcfac7820c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c98938de843e3cccadb4f03cb37eab2ed0cb212f9db2665d598586d6a442863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab99fa936fecc15b40c95b7635bbde219181f26dcad5bb16201e64e6ed49ce6a"
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
