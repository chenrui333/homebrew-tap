class TaskMasterAi < Formula
  desc "AI task manager for Cursor, Lovable, Windsurf, Roo, and more"
  homepage "https://www.task-master.dev/"
  url "https://registry.npmjs.org/task-master-ai/-/task-master-ai-0.25.1.tgz"
  sha256 "bdaa591f315be2066e6a69faa6cb2c0ac16d5f69d9e3e53c743595bae967389f"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/task-master --version")

    output = shell_output("#{bin}/task-master models 2>&1", 1)
    assert_match "No configuration file found in project", output
  end
end
