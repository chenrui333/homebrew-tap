class Mynav < Formula
  desc "Workspace and session management TUI"
  homepage "https://github.com/GianlucaP106/mynav"
  url "https://github.com/GianlucaP106/mynav/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "323a1461f90adc233a6778f32b6829b1ed366de39e34477f7c852afaa25facad"
  license "MIT"
  head "https://github.com/GianlucaP106/mynav.git", branch: "main"

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
