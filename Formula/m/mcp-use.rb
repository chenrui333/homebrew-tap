class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-3.3.0.tgz"
  sha256 "1c342f8c9aef21da33b0e82d876a78ac39a12ec5c0db205e63cc829b8f4ba573"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "3396f7598d26ac5b8f5b274c3df89e496b4f408fce1bf0511f5023b08a190ef2"
    sha256                               arm64_sequoia: "6865d07748b70b69993bef203f7d27c78e5d0005f201346748a37a7a319a7697"
    sha256                               arm64_sonoma:  "6865d07748b70b69993bef203f7d27c78e5d0005f201346748a37a7a319a7697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3235a2e84a98a12c3b6fe432b443abad51faba2ddcd193dba5a337e80876030d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "126d2cb3468eaf833c3ecfe9a2c7b2ec37aa4706ce3abf9525b6bd9f7d96f44b"
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
