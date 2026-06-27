class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-3.6.0.tgz"
  sha256 "49728e15a3d6cc78a6c1b9c6861cb2d623158fdc78ee8124974073918a820a66"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f101e143228a3e02efcb729c3ec886e68c0e624ec339a84a0f25b142d79f864f"
    sha256                               arm64_sequoia: "70d978dd7a4c41a0d69caf60d3bb593dbc0f955a57195f100fde9af54c4606ba"
    sha256                               arm64_sonoma:  "70d978dd7a4c41a0d69caf60d3bb593dbc0f955a57195f100fde9af54c4606ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6147d9dcc0500d5fea43d2ee1bfa56b5a9d9e96329849215029384848f7d674f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1d73643d5ed6dd95cf9e80fc85b3006165a85ae3b09b47af7e83394bdf8e81"
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
