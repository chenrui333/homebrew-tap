class ClaudeContextMcp < Formula
  desc "Code search MCP for Claude Code"
  homepage "https://github.com/zilliztech/claude-context/tree/master/docs"
  url "https://registry.npmjs.org/@zilliz/claude-context-mcp/-/claude-context-mcp-0.1.15.tgz"
  sha256 "0ecf4f4462345737ae5edd737ee7418cd6ebd92a33f7183a49addf41139bc50b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "5554d80539d316592ce62b5762eccbb505b104b4587f8fa72398c830fa6f5c27"
    sha256               arm64_sequoia: "8d4055c1b54d03b21bdcc20153e2e1ab5fe60f1947ad0a316e58c55c2f3e9911"
    sha256               arm64_sonoma:  "025f0d31be40ceadfd4418860b626663ef6e2e71de5f6106046ff7220142628e"
    sha256 cellar: :any, arm64_linux:   "0eb39cafba7a6d15582ca24262a89ccd2562956b141c54c1ca1683d55b51314f"
    sha256 cellar: :any, x86_64_linux:  "f2b2fb5add4d311ff3632079f5055df4b93fded4791c47fbb2e54e93803043e0"
  end

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
