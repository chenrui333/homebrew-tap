class Cclogviewer < Formula
  desc "Review Claude Code .jsonl files with a nice HTML UI"
  homepage "https://github.com/Brads3290/cclogviewer"
  url "https://github.com/Brads3290/cclogviewer/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1e95505212ae110ca1271eb3dc5c178a5913c3abe78337ea797e49c0ed7794d4"
  license "MIT"
  revision 1
  head "https://github.com/Brads3290/cclogviewer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af2dc9fa8248a35576da2f591440655d84a9f962f0eaaf2833f263d7bc7c2184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2dc9fa8248a35576da2f591440655d84a9f962f0eaaf2833f263d7bc7c2184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2dc9fa8248a35576da2f591440655d84a9f962f0eaaf2833f263d7bc7c2184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2773ec3a96b66e242652b55e320b8bfa23f1202726402131fb8a6dbb4cbb465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adaa5a0df153980e0f9f23f1642c42fed3847e27b6b9600398b3ca50e6bd83d9"
  end

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
