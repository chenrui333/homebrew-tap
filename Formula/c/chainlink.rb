class Chainlink < Formula
  desc "Lean issue tracker for AI-assisted development"
  homepage "https://github.com/dollspace-gay/chainlink"
  url "https://github.com/dollspace-gay/chainlink/archive/refs/tags/chainlink-1.6.0.tar.gz"
  sha256 "e0371c5e067a33040fd620457320ed55c74acf455bc5cd18e0c1ad6bed3af3c3"
  license "MIT"
  head "https://github.com/dollspace-gay/chainlink.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a8c52fbf75f44907be3468fc72fb49bd931d8e6a36077cfb8b825bb098e709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb8b1d27a3f94ffd8fa2fb71628e7e3854ddcd4d7b5c759229a21cfc556b169"
    sha256 cellar: :any,                 arm64_linux:   "26200e007cbe9aba6d369d8d8a16b84f788e46a06b15cea894924a3587c93f62"
    sha256 cellar: :any,                 x86_64_linux:  "f1fb775a2138451dc4a76079101c73a361e2969979e4b069ad03a4f3afbb1924"
  end

  depends_on "rust" => :build
  depends_on "python@3.15"
  depends_on "uv"

  deny_network_access!

  def fetch
    cd "chainlink" do
      # The release tag is newer than the crate's stale package version.
      inreplace "Cargo.toml", 'version = "0.1.3"', "version = \"#{version}\""
      inreplace "Cargo.lock", /(name = "chainlink-tracker"\nversion = )"0\.1\.3"/, "\\1\"#{version}\""
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # Embedded hooks must use Homebrew Python, not an ambient `python` executable.
    inreplace "chainlink/resources/claude/settings.json",
              "then python ", "then #{formula_opt_bin("python@3.15")}/python3.15 "
    system "cargo", "install", *std_cargo_args(path: "chainlink")
    # Templates, rules, Python hooks, and the MCP server are embedded in the binary.
    pkgshare.install "chainlink/resources"
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/chainlink --version")
    system bin/"chainlink", "init"
    assert_path_exists testpath/".claude/hooks/prompt-guard.py"
    assert_path_exists testpath/".claude/mcp/safe-fetch-server.py"
    system bin/"chainlink", "issue", "create", "Homebrew fixture", "--priority", "high"
    issue = JSON.parse(shell_output("#{bin}/chainlink export")).fetch("issues").first
    assert_equal "Homebrew fixture", issue.fetch("title")
    assert_equal "high", issue.fetch("priority")
    assert_equal "open", issue.fetch("status")
    system bin/"chainlink", "issue", "close", issue.fetch("id").to_s, "--no-changelog"
    closed = JSON.parse(shell_output("#{bin}/chainlink export")).fetch("issues").first
    assert_equal "closed", closed.fetch("status")
  end
end
