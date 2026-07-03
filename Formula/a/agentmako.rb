class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.5.0.tgz"
  sha256 "14ec43adbf6776e8ea8c3f073e12f3cd01f9cac0731ae5e14cc303e63a9745ba"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "6fc39738015c60ff39284b9bc45fef56352f772875945d9056ef4be090e5b85e"
    sha256               arm64_sequoia: "72d5c12232ddf6bbe276c16e9b12f8fa1e8d3fb81ea6eed4f2fb34d8adf8462c"
    sha256               arm64_sonoma:  "7d78e747d9fde7e946e31c25263ed71a9c9e8457a6b191ad812b7de5ed1a002d"
    sha256 cellar: :any, arm64_linux:   "835e61ae4f8c39e40dd20474f89cc1a2389d165fdc939abf1ef6c1f05f584eb6"
    sha256 cellar: :any, x86_64_linux:  "db4e36461fa8882d476deefc1b72ae92c676c1a94dafe3380de0655e7df57bff"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Build tree-sitter addons from source; upstream linux-arm64 prebuilds are x86_64.
    cd libexec/"lib/node_modules/agentmako" do
      system "npm", "rebuild", "tree-sitter-javascript", "tree-sitter-typescript", "--build-from-source"
    end
    %w[tree-sitter-javascript tree-sitter-typescript].each do |package|
      rm_r libexec/"lib/node_modules/agentmako/node_modules/#{package}/prebuilds"
    end

    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilds for non-native platforms/architectures
    native_prebuild = "#{OS.kernel_name.downcase}-#{Hardware::CPU.intel? ? "x64" : "arm64"}"
    libexec.glob("lib/node_modules/agentmako/**/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != native_prebuild
    end
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_match "Configuration:", shell_output("#{bin}/mako doctor")
  end
end
