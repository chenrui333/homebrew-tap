class Cclogviewer < Formula
  desc "Review Claude Code .jsonl files with a nice HTML UI"
  homepage "https://github.com/Brads3290/cclogviewer"
  url "https://github.com/Brads3290/cclogviewer/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1e95505212ae110ca1271eb3dc5c178a5913c3abe78337ea797e49c0ed7794d4"
  license "MIT"
  head "https://github.com/Brads3290/cclogviewer.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cclogviewer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cclogviewer --version")

    (testpath/"session.jsonl").write <<~JSON
      {"role":"user","content":"Hello"}
      {"role":"assistant","content":"Hi there!"}
    JSON

    system bin/"cclogviewer", "-input", testpath/"session.jsonl", "-output", testpath/"conversation.html"
    assert_match "<h1>Claude Code Conversation Log</h1>", (testpath/"conversation.html").read
  end
end
