class ClaudeContextMcp < Formula
  desc "Code search MCP for Claude Code"
  homepage "https://github.com/zilliztech/claude-context/tree/master/docs"
  url "https://registry.npmjs.org/@zilliz/claude-context-mcp/-/claude-context-mcp-0.1.14.tgz"
  sha256 "78c5117933539bfb2125efc7dbd9126e77552e717d88beb6c3f6b51c77e6a2e6"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => :build
  depends_on "node"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    ENV.append "CXXFLAGS", "-std=c++20"

    system "npm", "install", *std_npm_args

    package = libexec/"lib/node_modules/@zilliz/claude-context-mcp"
    system "npm", "rebuild", "--build-from-source", "--prefix", package

    faiss_buildpath = package/"node_modules/faiss-node/build"
    rm_r faiss_buildpath/"CMakeFiles" if (faiss_buildpath/"CMakeFiles").exist?
    %w[CMakeCache.txt .ninja_deps .ninja_log build.ninja].each do |file|
      path = faiss_buildpath/file
      rm path if path.exist?
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{OS.kernel_name.downcase}-#{arch}"
    (package/"node_modules").glob("tree-sitter*/prebuilds").each do |prebuilds|
      prebuilds.each_child do |dir|
        rm_r(dir) if dir.directory? && dir.basename.to_s != native
      end
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"brew-test","version":"1.0"}}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    output = pipe_output("OPENAI_API_KEY=test MILVUS_ADDRESS=127.0.0.1:19530 #{bin}/claude-context-mcp 2>&1", json, 1)
    assert_match "Context MCP Server", output
    assert_match "index_codebase", output
  end
end
