class CopilotCli < Formula
  desc "Copilot coding agent directly to your terminal"
  homepage "https://github.com/github/copilot-cli"
  url "https://registry.npmjs.org/@github/copilot/-/copilot-0.0.354.tgz"
  sha256 "cc61ad9201c75b0ba3442d32861ddba876cd7cd780c94fc64e5fab50c51c0bcb"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "abb79764313faad28bba1e9e22f760bedfa06661cedefe2e11e5c09bac2d8d6a"
    sha256 cellar: :any, arm64_sequoia: "97abeee01e2886a93fd9adfcd84df780fe2babc9131689629149c27ae310577a"
    sha256 cellar: :any, arm64_sonoma:  "97abeee01e2886a93fd9adfcd84df780fe2babc9131689629149c27ae310577a"
  end

  depends_on :macos # TODO: add linux support
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@github/copilot"

    # Remove non-native binaries, like `keytar.node`, `pty.node`, `spawn-helper`
    prebuilds = node_modules/"prebuilds"
    prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Remove non-native sharp prebuilds
    sharp_prebuilds = node_modules/"sharp/node_modules/@img"
    keep = %W[sharp-#{os}-#{arch} sharp-libvips-#{os}-#{arch}]
    sharp_prebuilds.each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/copilot --version")

    output = shell_output("#{bin}/copilot -p 'Fix the bug in main.js' --allow-all-tools 2>&1", 1)
    assert_match "Error: No authentication information found", output
  end
end
