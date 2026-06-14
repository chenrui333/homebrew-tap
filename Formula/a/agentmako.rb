class Agentmako < Formula
  desc "Local project intelligence CLI and MCP server for codebases and databases"
  homepage "https://github.com/drhalto/agentmako"
  url "https://registry.npmjs.org/agentmako/-/agentmako-0.3.2.tgz"
  sha256 "ec03cafde7fe0e287e60b3b23b82d0f54148c720a648c6acbc1e6a71d5cb7295"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256               arm64_tahoe:   "d66392abe226814bd23b02c2343627d0d4d6b1bf22704668009f9ab943ea5996"
    sha256               arm64_sequoia: "647efc7681bd48637e2d3dbd5bb92dd2e7d5ffa29e547b0ee385a042ef3bd2a1"
    sha256               arm64_sonoma:  "8e50b87bf345ea540ee7f7e9534064207bb64ed91e7dc99757bbd32368cc68a1"
    sha256 cellar: :any, arm64_linux:   "769f31f8f117a18521e9bf93cf68f0d9078e400b405c1eb9cfd344517d47022d"
    sha256 cellar: :any, x86_64_linux:  "6305d70427bbf201ea7493b71bb72af57701e935fcfe7fa4e0b33610afbfd008"
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
