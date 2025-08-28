class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.4.tgz"
  sha256 "550f0211d84eaadd6478b8f9432bcffc197dbeec74d89c4635dac145d9cf4d13"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b48f1ca141dd26e3ac58aa0228017fb8a408b94a320bae60dba1e68913b2f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d7d08ebc75719aaec1b87da0d956d8d8a469c0fd48f22b5b5600e88a469d36a"
    sha256 cellar: :any_skip_relocation, ventura:       "af716815fcc168d69f29914164b4434769a52b219d94807ebc105d8fbed430c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b4811f295a662b0d4386c3b9fd78dd4ee725846ff5a26523f59e1508f88363"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudekit --version")
    assert_match "Hooks:", shell_output("#{bin}/claudekit list")
    assert_match ".claudekit/config.json not found", shell_output("#{bin}/claudekit doctor 2>&1", 1)
  end
end
