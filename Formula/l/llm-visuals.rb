class LlmVisuals < Formula
  desc "Live terminal dashboard for a locally running LLM"
  homepage "https://github.com/DingoOz/llm-visuals"
  url "https://github.com/DingoOz/llm-visuals/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "5194738c0bc93920d676f153e2cc7d1862915bf41e29e52180a8ecb8ce13091e"
  license "MIT"
  head "https://github.com/DingoOz/llm-visuals.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "ad121568571ed42d33552be5a1be91a7f8a64c400ac2a03f3ef9aa3c89944637"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddbc2a355fee535988da08500ddd329685302afa07e4732856844ffd5474ab5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77097bd53dffaf774acace935b3bb5b8127b871ed7bfe8375509302ab90c67c"
    sha256 cellar: :any,                 arm64_linux:   "e57424d3d2b20c391ab84453e58cee0b36ce53be29d6d601c14820733faf49df"
    sha256 cellar: :any,                 x86_64_linux:  "0c107d78a206de54642e5486f82ee510ca6b82ec5bcaf18ea6741c89940b6b64"
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
    assert_match version.to_s, shell_output("#{bin}/llm-visuals --version")

    touch testpath/"log.db"
    output = shell_output("#{bin}/llm-visuals --bench-report --log-db #{testpath}/log.db 2>&1", 1)
    assert_match "no bench runs logged yet", output

    output = shell_output("#{bin}/llm-visuals --alerts bogus 2>&1", 2)
    assert_match "invalid value 'bogus' for '--alerts", output
  end
end
