class CopilotCli < Formula
  desc "Copilot coding agent directly to your terminal"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-0.0.354.tgz"
  sha256 "cc61ad9201c75b0ba3442d32861ddba876cd7cd780c94fc64e5fab50c51c0bcb"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9956df9306aa869de974886e55bae45dcf9da70408746eeb68f64cba4594b766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf730ebce1511b78f076aa51f7694a55bbbf56517be49df7e9eab859902bf7d"
  end

  depends_on :macos # TODO: add linux support
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@github/copilot/node_modules"

    # Remove keytar-forked-forked non-native binaries
    keytar_prebuilds = node_modules/"keytar-forked-forked/prebuilds"
    keytar_prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove node-pty non-native binaries
    node_pty_prebuilds = node_modules/"node-pty/prebuilds"
    node_pty_prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/copilot --version")

    output = shell_output("#{bin}/copilot -p 'Fix the bug in main.js' --allow-all-tools 2>&1", 1)
    assert_match "Error: No authentication information found", output
  end
end
