class Lazynpm < Formula
  desc "TUI for npm"
  homepage "https://github.com/jesseduffield/lazynpm"
  url "https://github.com/jesseduffield/lazynpm/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "841583d686fa55872a4136627c0bed9d15edd6f87989a3a64ff7b28a0784254e"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.buildSource=binaryRelease"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazynpm --version")
    assert_match "gui", shell_output("#{bin}/lazynpm --config")
  end
end
