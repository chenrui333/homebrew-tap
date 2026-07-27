class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.6.0.tgz"
  sha256 "333857fe5556234777ca57725986d294eb0925785e05d664688f20037e35f996"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "e75c547777854dc62038a000e7fe34a10f40635a3c957d47cb7ad4e90d033352"
    sha256               arm64_sequoia: "af9e2801b2d01dbcf87536a86ec5499be7ad589c4e5fe53d609be6086f9e8505"
    sha256               arm64_sonoma:  "db20e0c10eddb1faaaa8cb08399b8cb22fc2a3ff3d0fc1d650628ffc41f3c08e"
    sha256 cellar: :any, arm64_linux:   "6c8d98d01cc89bff8b00ed694922813e5fc2137a1ce97e1b3c5e9bb59d78ed83"
    sha256 cellar: :any, x86_64_linux:  "151b8b0e3359ba62ad6326bafe13ebaa6fa966b59b003da7fc2ddce4d497f2f3"
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
