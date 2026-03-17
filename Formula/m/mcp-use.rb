class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.19.0.tgz"
  sha256 "9da1a9cfc714e02cf2b653e3ba0ea46b99fd313aeeb77f3869adf57e19eacf8a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "4b19039b51a0b4311de16fee5ba9ab2a7b2bb96f36efca2586614533dafe5de5"
    sha256                               arm64_sequoia: "387e69535cc54920c5c9e95c4d9145c86ebf4a0b61fab86a20a7d0232722ed16"
    sha256                               arm64_sonoma:  "387e69535cc54920c5c9e95c4d9145c86ebf4a0b61fab86a20a7d0232722ed16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fc6a4db49d8ea932b0ef6cf44e8cc80a13adcb3d52ddeacf1053c31fa3dd8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6fe851dd916d9261f8c9b0f8c7ffb317dcb4804bdd2431d9116e3546d525243"
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
