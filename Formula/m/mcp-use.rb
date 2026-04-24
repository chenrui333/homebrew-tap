class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-3.1.0.tgz"
  sha256 "114c07c4bc594e11cbb30cf10de4f34cc92a33c467ba753411751764bbae1571"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "1ce48e996f26ffb177f66179e9adaf5d9454f81777ad359eb9c71abaa080465b"
    sha256                               arm64_sequoia: "40f9d70684b6d1d1b069799714ba633496b1f0a76216935138a38d74b29b0e27"
    sha256                               arm64_sonoma:  "40f9d70684b6d1d1b069799714ba633496b1f0a76216935138a38d74b29b0e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf8bf03a859acfb48398fe72807afc5b4ff2b9f07082599c11067b73b265ddc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "804295e132d202a6ea7192462a1194605925593a4af50c92c27e0fd0cf49f868"
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
