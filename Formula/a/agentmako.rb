class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.4.3.tgz"
  sha256 "3b1886059337803ef5d2af6a24e00b84eb0bdba6a9b440449d4bfc24a1697ac2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "9445a4100a688767e2add4f222b96f5c561b889263eb1764a7e64e518a19d24b"
    sha256               arm64_sequoia: "df7362a8584af3ab4f022338478199f6bb3151ce21da4023133745c82ff0e42f"
    sha256               arm64_sonoma:  "e1ef404200c4dceee3732721ceb743cbb8f5bc158b8537c9f8e7bcd2dd563216"
    sha256 cellar: :any, arm64_linux:   "8eae2975192aac36fe08f4a549f04d348aff6cd2b8f0a5738bfa3fd5d5d8b043"
    sha256 cellar: :any, x86_64_linux:  "f1e7c903afeb79064035e7f45588daad20a3b07364078c9ae44a87af4cbe16f4"
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
