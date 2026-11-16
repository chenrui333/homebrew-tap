class ClaudeContextMcp < Formula
  desc "Code search MCP for Claude Code"
  homepage "https://github.com/zilliztech/claude-context/tree/master/docs"
  url "https://registry.npmjs.org/@zilliz/claude-context-mcp/-/claude-context-mcp-0.1.16.tgz"
  sha256 "8decb2a585fd1c527df593f47cfd3b29f7d35ff863ed45ccbb920ff53a8a4155"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "046571634cacc6962a195073a599b346be588f9f602b78df5defeec67c7f7541"
    sha256 cellar: :any, arm64_sequoia: "e8a06d53f722150e2808382986895e217a34b41d4d11e1800f12cb183ebec900"
    sha256 cellar: :any, arm64_linux:   "cddafa8370cb4a32adbc986a10df71ece1da00bb5bbc79785d64d123b97c3213"
    sha256 cellar: :any, x86_64_linux:  "3ee08c093b7ed773379317557b20e10956bfabf8a90fe6289e186932dc584859"
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

  resource "faiss" do
    url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.7.4.tar.gz"
    sha256 "d9a7b31bf7fd6eb32c10b7ea7ff918160eed5be04fe63bb7b4b4b5f2bbde01ad"
  end

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
    system "npm", "install", "cmake-js@7.2.1", *std_npm_args(prefix: buildpath/"cmake-js-fetch")
  end

  def install
    ENV.append "CXXFLAGS", "-std=c++20"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")

    system "npm", "install", "--offline", "--ignore-scripts", *std_npm_args

    package = libexec/"lib/node_modules/@zilliz/claude-context-mcp"
    faiss_node = package/"node_modules/faiss-node"
    resource("faiss").stage faiss_node/"deps/faiss"
    package_json = JSON.parse((faiss_node/"package.json").read)
    package_json.delete("devDependencies")
    package_json["scripts"]["install"] = "npm run build"
    (faiss_node/"package.json").atomic_write JSON.pretty_generate(package_json)
    cd faiss_node do
      system "npm", "install", "--offline", "cmake-js@7.2.1", *std_npm_args(prefix: false), "--no-save"
    end

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
