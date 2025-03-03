class Kt < Formula
  desc "Kafka command-line tool that likes JSON"
  homepage "https://github.com/fgeller/kt"
  url "https://github.com/fgeller/kt/archive/refs/tags/v13.1.0.tar.gz"
  sha256 "20cffe44f0f126ee42c634427cc3cdb6705e33dd4de3647a8c4a84ccec1d25f3"
  license "MIT"
  head "https://github.com/fgeller/kt.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kt --version")

    output = shell_output("#{bin}/kt produce -topic greetings 2>&1", 1)
    assert_match "Failed to open broker connection", output
  end
end
