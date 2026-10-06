class Recall < Formula
  desc "Search and resume Claude Code and Codex CLI conversations"
  homepage "https://github.com/zippoxer/recall"
  url "https://github.com/zippoxer/recall/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9defdf83adfe7ee4b3fec8c84d7b1c9037ae57abce8be14f5771142cfa61acbf"
  license "MIT"
  head "https://github.com/zippoxer/recall.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6a3a75ed5a6bb69ffb4fe2faa73347b7a6b8af66517e1f4a42914bad16a8dc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab79554a452e95a9980db22581b3785c1edebf58b62ab354cc80a818bb9bb255"
    sha256 cellar: :any,                 arm64_linux:   "352393434b563c5b33a2fb0a4b4400c562277eec443779cb67cf63532e5a51aa"
    sha256 cellar: :any,                 x86_64_linux:  "754099c174f99397a6c6ba106b45c6244b7cd571fda6b78238e1e9900c7dc94f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    session_dir = testpath/".codex/sessions/2026/01/01"
    session_dir.mkpath

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
