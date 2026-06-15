class TaskMasterAi < Formula
  desc "AI task manager for Cursor, Lovable, Windsurf, Roo, and more"
  homepage "https://www.task-master.dev/"
  url "https://registry.npmjs.org/task-master-ai/-/task-master-ai-0.43.1.tgz"
  sha256 "5b792287ec2e61d3428bf8bf680fe6df0fecfe77554342c01ac0feebad25c5a5"
  license "MIT" # should be "LicenseRef-MIT-with-commons-clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "b73c8936832232cded1bf7b33544e1703ff2a4312f2e15830377ccb6f30777ed"
    sha256               arm64_sequoia: "66870ece186a4d08ee4ee4bfc3791679d899a25188c621cbbc1d8cf98b5b74db"
    sha256               arm64_sonoma:  "66870ece186a4d08ee4ee4bfc3791679d899a25188c621cbbc1d8cf98b5b74db"
    sha256 cellar: :any, arm64_linux:   "e2cb45228de61b4df9d32b71e1ca8dadd36da910a211aba339d672f49af6b4c2"
    sha256 cellar: :any, x86_64_linux:  "0a78cec072e91b25eba9692416665fee67a6a3b4286f1361fe7b01b4dcb81cc4"
  end

  depends_on "node"

  on_macos do
    depends_on "pcre2"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    node_modules = libexec/"lib/node_modules/task-master-ai"
    node_modules.glob("node_modules/@anthropic-ai/claude-code/vendor/ripgrep/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}" }
    node_modules.glob("node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}" }
    node_modules.glob("node_modules/node-pty/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    node_modules.glob("node_modules/tree-sitter-bash/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    if OS.mac?
      node_modules.glob("node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep/*/ripgrep.node").each do |node|
        # The SDK also ships rg; remove the shared object because its Mach-O install name cannot be relocated.
        rm node
      end
    end

    codex_arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    codex_os = OS.mac? ? "apple-darwin" : "unknown-linux-musl"
    codex_vendor = node_modules/"node_modules/@openai/codex/vendor"
    codex_vendor.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{codex_arch}-#{codex_os}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/task-master --version")

    output = shell_output("#{bin}/task-master models 2>&1", 1)
    assert_match "No configuration file found in project", output
  end
end
