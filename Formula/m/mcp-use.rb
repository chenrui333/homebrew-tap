class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-3.6.0.tgz"
  sha256 "49728e15a3d6cc78a6c1b9c6861cb2d623158fdc78ee8124974073918a820a66"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "7bb49a4de0c5a29721aea89caf17cf2a8755dd7218fa24381c8c5e4140a87911"
    sha256                               arm64_sequoia: "8f59755f1c3e108402e706503c44ef736dfc306cc897d69d4fe2bc28847b1a26"
    sha256                               arm64_sonoma:  "8f59755f1c3e108402e706503c44ef736dfc306cc897d69d4fe2bc28847b1a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a20f4f2a8c798ef5869ffa31aef23c4a4a5d5061790363baceaf2454c3a9db47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a99dbc227cb560d91565aedeb4dff0578e577db215c871ad1ca4c5d3c87620d"
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
