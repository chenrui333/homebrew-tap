class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.3.2.tgz"
  sha256 "ec03cafde7fe0e287e60b3b23b82d0f54148c720a648c6acbc1e6a71d5cb7295"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0a6647d6c0bc4897f0642371c3fcf279480c06823d3aac5c82460120d28903d3"
    sha256                               arm64_sequoia: "b124f2a15a996092c87de560ff63713b32a5a70bf2c50c8fe0daec23f98ec0fe"
    sha256                               arm64_sonoma:  "6a721a47846a576e460449dabb4b8b11b77fbd08849dbe1c660dd0d0135ebdf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e9b39ce2b8da3f8dc23b675a0353d89287871b911f4f5bb8ddfe89513e933b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7714542dcb5ead2fa945c9f68edc7feaea0bbc4a900174e008291863ffa83576"
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
    assert_match "agentmako CLI", shell_output("#{bin}/agentmako --help")
    assert_match "Configuration:", shell_output("#{bin}/mako doctor")
  end
end
