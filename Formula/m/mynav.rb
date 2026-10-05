class Mynav < Formula
  desc "Workspace and session management TUI"
  homepage "https://github.com/GianlucaP106/mynav"
  url "https://github.com/GianlucaP106/mynav/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "323a1461f90adc233a6778f32b6829b1ed366de39e34477f7c852afaa25facad"
  license "MIT"
  head "https://github.com/GianlucaP106/mynav.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b4138f634bf5f35d1fe8a97b1eb3775e22e38b7f850d06bf2e1c1f45e74109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b4138f634bf5f35d1fe8a97b1eb3775e22e38b7f850d06bf2e1c1f45e74109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1527ab1304cf19ae1a390b09bbf205b79359acd55e1cff367afa3f2995ac74d2"
    sha256 cellar: :any,                 x86_64_linux:  "8cf38d4dab892edf6484a2081161ac0a58eac1df83b570da73edfd5763a1d0c9"
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
    assert_match version.to_s, shell_output("#{bin}/mynav -version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"mynav", "-path", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "failed to initialize tcell screen", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
