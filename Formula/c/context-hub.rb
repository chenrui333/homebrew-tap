class ContextHub < Formula
  desc "Search and retrieve LLM-optimized documentation and skills"
  homepage "https://github.com/andrewyng/context-hub"
  url "https://registry.npmjs.org/@aisuite/chub/-/chub-0.1.4.tgz"
  sha256 "ca9fb94a21d3b5ae3025923ded305dd11f189626da5adab48a8b947bc523888f"
  license "MIT"
  head "https://github.com/andrewyng/context-hub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "12e10fbd4966a8c6d7740abc86fadad63ccebd6295c9c898037a2d5dfd9b3747"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    cd(build.head? ? "cli" : ".") do
      system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
    end
  end

  def install
    rm_r buildpath/"npm-fetch"
    cd(build.head? ? "cli" : ".") do
      system "npm", "install", "--offline", *std_npm_args
    end
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["CHUB_TELEMETRY"] = "0"
    assert_match version.to_s, shell_output("#{bin}/chub --cli-version")

    system bin/"chub", "annotate", "homebrew/test", "Local documentation note", "--json"
    annotations = JSON.parse(shell_output("#{bin}/chub annotate --list --json"))
    assert_equal "Local documentation note", annotations.find { |entry| entry["id"] == "homebrew/test" }.fetch("note")
    cleared = JSON.parse(shell_output("#{bin}/chub annotate homebrew/test --clear --json"))
    assert_equal true, cleared.fetch("cleared")
    assert_path_exists bin/"chub-mcp"
  end
end
