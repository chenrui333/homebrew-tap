class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.2.0.tgz"
  sha256 "f72e111a0c56b7dd4421bcc1b28201c5ea5e1f000c6df610639f445f3961cf6e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9c0697e45576759f2c759b64170580c5d7784d470603476c3f06068299fa4d94"
    sha256                               arm64_sequoia: "ab6fddccdf2df987a5c6b84d79f11e9dcc6a544f72066abf1d345f5af4675161"
    sha256                               arm64_sonoma:  "2be410e681c22922b2ef2089137001a1b282186ebf4f32fd3ddaaba8d7e9bc57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a95db86a02d2228e8f83d289fda8d6a45b98d216fc9188e54fdde6ee7fed0322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885e100cad0009c564b1d8fa6302b560272fee06b2d423cf39f4bff3ed6db483"
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
