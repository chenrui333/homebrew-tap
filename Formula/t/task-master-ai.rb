class TaskMasterAi < Formula
  desc "AI task manager for Cursor, Lovable, Windsurf, Roo, and more"
  homepage "https://www.task-master.dev/"
  url "https://registry.npmjs.org/task-master-ai/-/task-master-ai-0.43.1.tgz"
  sha256 "5b792287ec2e61d3428bf8bf680fe6df0fecfe77554342c01ac0feebad25c5a5"
  license "MIT" # should be "LicenseRef-MIT-with-commons-clause"

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
