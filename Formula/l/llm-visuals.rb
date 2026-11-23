class LlmVisuals < Formula
  desc "Live terminal dashboard for a locally running LLM"
  homepage "https://github.com/DingoOz/llm-visuals"
  url "https://github.com/DingoOz/llm-visuals/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "5194738c0bc93920d676f153e2cc7d1862915bf41e29e52180a8ecb8ce13091e"
  license "MIT"
  head "https://github.com/DingoOz/llm-visuals.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llm-visuals --version")

    touch testpath/"log.db"
    output = shell_output("#{bin}/llm-visuals --bench-report --log-db #{testpath}/log.db 2>&1", 1)
    assert_match "no bench runs logged yet", output

    output = shell_output("#{bin}/llm-visuals --alerts bogus 2>&1", 2)
    assert_match "invalid value 'bogus' for '--alerts", output
  end
end
