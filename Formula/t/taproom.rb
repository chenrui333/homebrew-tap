class Taproom < Formula
  desc "TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e41380bdf43768ff3c41ff3e9495b72f01eb2b154857af7b53bbd42395ec71e6"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fdc7504daa8e1d690ff15f13a35832580895b5bb89475d57894376cd10c43eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fdc7504daa8e1d690ff15f13a35832580895b5bb89475d57894376cd10c43eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fdc7504daa8e1d690ff15f13a35832580895b5bb89475d57894376cd10c43eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c5008baa8402658f32ca13bf714e78e5eb6926448dd409d4e6169b38cb5c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab86da20e75dc377232ca90f74e5a4c91d22ef950d324ab4ee21aa36eab20767"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    # Skip test on Linux GitHub Actions runners due to TTY issues
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"taproom", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "[1/6] Loading all Formulae...\r\n[2/6] Loading all Casks...", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
