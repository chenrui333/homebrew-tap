class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-3.1.3.tgz"
  sha256 "458e6607f7bd1e8ec9c1686ebe337b077cb81b3236ceed0ff9e9997c9d1af66c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "8dcb65fa4c24c7518e5e757de93aa6c0133be5901b2b74a591e89ab7664031fe"
    sha256                               arm64_sequoia: "2bb71885f51d95dfd2d5f4c255d4ec4a46ce9e1ce5394c209574ed58377fc2d6"
    sha256                               arm64_sonoma:  "2bb71885f51d95dfd2d5f4c255d4ec4a46ce9e1ce5394c209574ed58377fc2d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79ac53cf52c3bd127820f319b90b76d0d57d7f7051a5b544c19c3e8d52f1475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf19572e7137d764f33f717538c6b02855a78d4b5989ef8f5fff094181392fb"
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
