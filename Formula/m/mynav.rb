class Mynav < Formula
  desc "Workspace and session management TUI"
  homepage "https://github.com/GianlucaP106/mynav"
  url "https://github.com/GianlucaP106/mynav/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "323a1461f90adc233a6778f32b6829b1ed366de39e34477f7c852afaa25facad"
  license "MIT"
  head "https://github.com/GianlucaP106/mynav.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "151f6d60cbfb129253eb809cf883673a4c5e33740d3d8d8a0afd4097380eb294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2777bcb6aa28fb7bc01fa8c8be30649361c1c5bc92a18e5f428292209acce261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "752b66f53fa965f964962169e6585cc44aa85e4f8845314def6305a5228c4e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28d6e379027f568b00e4621d2e192250c06bb0541caa09a2a5fd85b66863952"
  end

  depends_on "go" => :build

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
