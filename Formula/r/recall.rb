class Recall < Formula
  desc "Search and resume Claude Code and Codex CLI conversations"
  homepage "https://github.com/zippoxer/recall"
  url "https://github.com/zippoxer/recall/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9defdf83adfe7ee4b3fec8c84d7b1c9037ae57abce8be14f5771142cfa61acbf"
  license "MIT"
  head "https://github.com/zippoxer/recall.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bc397bfe969d8309f1dc82a2810d1f4c0ba358e2d15fce21a35dc80cc3a8571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6691d039d019781397c801a3e1765a380b68bdb8ccaebf57b98a1d2048e89d37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411df93c61ec4bbe89fd4fe066173099fecec583481f6a056febb7c011fe9992"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6f041fe783be84e265239b71371146d05470499879efe991e5c702662efe3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77feaa36c751ade680d678851649b09dced402f4721fb33e10aa187ab5517979"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    session_dir = testpath/".codex/sessions/2026/01/01"
    mkdir_p session_dir

    (session_dir/"rollout-test.jsonl").write <<~JSONL
      {"type":"session_meta","timestamp":"2026-01-01T00:00:00Z","payload":{"id":"test-codex-123","cwd":"/tmp/project","git":{"branch":"main"}}}
      {"type":"response_item","timestamp":"2026-01-01T00:00:01Z","payload":{"role":"user","content":[{"type":"input_text","text":"find my homebrew tap migration notes"}]}}
    JSONL

    ENV["RECALL_HOME_OVERRIDE"] = testpath.to_s
    command = "#{bin}/recall search homebrew --source codex --limit 5"
    output = shell_output(command)
    parsed = JSON.parse(output)

    assert_equal "homebrew", parsed["query"]
    assert_equal "test-codex-123", parsed["results"].first["session_id"]
    assert_equal "codex", parsed["results"].first["source"]
  end
end
