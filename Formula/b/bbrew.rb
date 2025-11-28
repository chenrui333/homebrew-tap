class Bbrew < Formula
  desc "Bold Brew (bbrew) - A Homebrew TUI Manager"
  homepage "https://bold-brew.com/"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "4416f2fd52909324fb59a1d09860d749dcb8b232abdf267a66a4f9f26f3a2645"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "trunk"

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
