class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.19.0.tgz"
  sha256 "9da1a9cfc714e02cf2b653e3ba0ea46b99fd313aeeb77f3869adf57e19eacf8a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "e271607a3ee77f11c6ad1e82dad8fae84e97a1e61d9451ebb38e25d594ff887e"
    sha256                               arm64_sequoia: "7e18c3c7b69ec81450ac41cb8070f467a88249c83ca7cf352dcdbff3fea490e5"
    sha256                               arm64_sonoma:  "7e18c3c7b69ec81450ac41cb8070f467a88249c83ca7cf352dcdbff3fea490e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6da6206a4b6b6476efa4e92ac96d557d8720aaf33cfe4c15793fc5e362e132d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6218b6a300a29108b0928d5c41ed627c8f7a00ad20a4788225d48d7164f3225c"
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
