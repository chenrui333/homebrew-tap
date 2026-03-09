class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.18.2.tgz"
  sha256 "15c706b9133e7f00d2ad1c28323c79e2c6aa9c34a9a2ff86e4bf3506e62dd591"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6e64e8906694d63769320ee34a34d42afa65118ed7571d59770bc8cb53a4a8aa"
    sha256                               arm64_sequoia: "8657534f9354a3b99962d823a8c3b119dd474be06141a069b94cd4f35ec47380"
    sha256                               arm64_sonoma:  "8657534f9354a3b99962d823a8c3b119dd474be06141a069b94cd4f35ec47380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05e8d04d8971554f8784e68f8fabda513d26e7a9e4cec1e5aa447979e003ddfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb081c648e7490f88c3e74a31527cc9080e3d37b702f689a5550909382ddc6c"
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
