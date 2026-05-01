class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-3.1.2.tgz"
  sha256 "9fecaaa261d3b1768116a0e10994f95d69a54b9b0fe75552d831f73641b612d7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9656a4fd84e8e44f5a03ce65c0149e3a4672f991feae12ff39efa6d7ceb1954f"
    sha256                               arm64_sequoia: "eda50d76e819a79124b9b1ab8422855b5fc35bde27ee2d609dd956abac91d0a0"
    sha256                               arm64_sonoma:  "eda50d76e819a79124b9b1ab8422855b5fc35bde27ee2d609dd956abac91d0a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eca1fb9ec319928d32e85e5edae3d47fbe92fdb58a8acf5ecef4c9e97ec8108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e7338dd04ceb63acf3efbf0b23657c6f3f11e7ff02de4467b75bc8268f8a0dd"
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
