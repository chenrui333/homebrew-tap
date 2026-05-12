class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "8714222bfa945b4f331d29eb6b486b9cdf0d9538650d40445c0575478662f680"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyenv --version 2>&1")
  end
end
