class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "9a46c765ce01b5d6e7c57f616b5f9a096ad86e97947863d9d7bccaf9179c49d3"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/0xjuanma/golazo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golazo --version")

    output = shell_output("#{bin}/golazo --definitely-invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
