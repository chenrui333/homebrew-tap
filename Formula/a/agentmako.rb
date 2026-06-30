class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.4.3.tgz"
  sha256 "3b1886059337803ef5d2af6a24e00b84eb0bdba6a9b440449d4bfc24a1697ac2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "6a4a539fc98c75bf26644e1649f894a735b0cded57bf24692d0c3bbf8c3a9488"
    sha256               arm64_sequoia: "db73665e6f7361700a5a6200cd283e3f09705e5b22e8e34a163daa77f782dee4"
    sha256               arm64_sonoma:  "530201cd81e8ffe62879608cba4ac01f5e46a2a16ef937aaa3d1548abbb0aa8e"
    sha256 cellar: :any, arm64_linux:   "c2442047a2f21a813449d75a9a3c108dbc5e61b469690c220c81526fa497e2db"
    sha256 cellar: :any, x86_64_linux:  "8ef258e5ac58664a66e47efaf5d217b4b2fb18e62c5738bf24d74dd9e0055d25"
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
