class Cclogviewer < Formula
  desc "Review Claude Code .jsonl files with a nice HTML UI"
  homepage "https://github.com/Brads3290/cclogviewer"
  url "https://github.com/Brads3290/cclogviewer/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1e95505212ae110ca1271eb3dc5c178a5913c3abe78337ea797e49c0ed7794d4"
  license "MIT"
  head "https://github.com/Brads3290/cclogviewer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c0442d845a905f1779bd206de87a66a7fe091864b26ecf89d522099b5a19ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7462a6c9bc52721d9600feedf0baba8760c80c89e99b7e903cd40f38cc6ddb"
    sha256 cellar: :any_skip_relocation, ventura:       "45f0d47139f5902ccbea5217aad0eaffbfccab20c4926d7f00e533c2369011a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd492b16dc5decb4f6a724cf86a67265bc3da9f3657f3da9794d584845668bb6"
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
