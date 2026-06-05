class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-3.3.1.tgz"
  sha256 "f1223348c6e4846a3bbc0b28d84344cf120e26e3995f17c1e6a76321e768e7f3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "96883969783f16a5d3f4ae745f4f4d46ebfb36befcfe66b777c69437ae0ae071"
    sha256                               arm64_sequoia: "15f9f5d807ccab5ddb3f07fba24104b51e03d3e0928fac9dc3c5ccf46b2b0f52"
    sha256                               arm64_sonoma:  "15f9f5d807ccab5ddb3f07fba24104b51e03d3e0928fac9dc3c5ccf46b2b0f52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebcfa515fd8668d1d4ff4f4dea100636d7a594a14a3d434c702affc464953d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7836d8a1d725f92d885d7001475508e1aeb0fe2743b8bfb760edea91158a9d87"
  end

  depends_on "typescript" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    if OS.linux?
      # ext-apps vendors Bun platform packages; keep glibc builds but remove
      # musl variants to satisfy linkage checks on Homebrew Linux runners.
      libexec.glob("lib/node_modules/**/@oven/bun-linux-*-musl*").each(&:rmtree)
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-use --version")

    (testpath/"tsconfig.json").write <<~JSON
      {
        "compilerOptions": {
          "target": "ES2020",
          "module": "ESNext",
          "moduleResolution": "bundler",
          "outDir": "./dist",
          "rootDir": "./src",
          "strict": true,
          "esModuleInterop": true,
          "skipLibCheck": true
        },
        "include": ["src/**/*"],
        "exclude": ["node_modules"]
      }
    JSON

    (testpath/"src/index.ts").write <<~TYPESCRIPT
      import { MCPServer } from "mcp-use/server";

      const server = new MCPServer({
        name: "test-mcp-server",
        version: "1.0.0",
      });

      export default server;
    TYPESCRIPT

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-mcp-use",
        "version": "1.0.0",
        "description": "Test project for mcp-use",
        "main": "dist/index.js",
        "type": "module",
        "devDependencies": {
          "mcp-use": "^1.21.2",
          "typescript": "^5.0.0"
        }
      }
    JSON

    system "npm", "install", *std_npm_args(prefix: false)
    system bin/"mcp-use", "build"

    assert_path_exists testpath/"dist/index.js"
    assert_match "test-mcp-server", (testpath/"dist/index.js").read
  end
end
