class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.4.2.tgz"
  sha256 "4c7a52fbfad73c354526b9b07a812b1de408f9d3bdbe1cedeb97a3b0fffc08db"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "371c2b4cdfc5040d5f3240c50ae77003a5f891338b526c2fe932ea1d86e0f692"
    sha256               arm64_sequoia: "ac5c9037af45c9232ebdd710fba3750c389acb97f15b70211a0c18eee1f80c8c"
    sha256               arm64_sonoma:  "6da481dc5e32ef4305517354dab3b1a295e6cd04745243f0da0cb2f9eb7ed278"
    sha256 cellar: :any, arm64_linux:   "32850f424b58571f59f4af2d36fe00b749ea48495e78c02b978ff77148d82f75"
    sha256 cellar: :any, x86_64_linux:  "09c660c7272cb0fa27cdb5d6e4d0a582394d9b849e0b7d07c0a9157e94c1a428"
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
