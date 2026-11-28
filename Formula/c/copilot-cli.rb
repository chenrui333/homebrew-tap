class CopilotCli < Formula
  desc "Copilot coding agent directly to your terminal"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-1.0.117.tgz"
  sha256 "3814643b3a23512b5fd62bfb8a308d6dc7863f85c39b2f2a53fbd73e2b119196"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "50af795baa9853046c82ea511ba14db8394477da8cbdb0c09a87ece68e3e3947"
    sha256 cellar: :any_skip_relocation, all: "2784e71ddec8c1240448d3b564d40d17edde0c061e80511c750aa3f805fa7330"
  end

  depends_on :macos # TODO: add linux support
  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/copilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/copilot --version")

    output = shell_output("#{bin}/copilot -p 'Fix the bug in main.js' --allow-all-tools 2>&1", 1)
    assert_match "Error: No authentication information found", output
  end
end
