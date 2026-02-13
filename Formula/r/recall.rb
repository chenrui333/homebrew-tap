class Recall < Formula
  desc "Search and resume Claude Code and Codex CLI conversations"
  homepage "https://github.com/zippoxer/recall"
  url "https://github.com/zippoxer/recall/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9defdf83adfe7ee4b3fec8c84d7b1c9037ae57abce8be14f5771142cfa61acbf"
  license "MIT"
  head "https://github.com/zippoxer/recall.git", branch: "main"

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
