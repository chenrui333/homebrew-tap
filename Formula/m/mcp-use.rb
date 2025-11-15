class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.2.1.tgz"
  sha256 "3b8696cc184720205b614573a40375fba429008a3770ce81fc26cf7baa7aee4f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0ff9416bd9629878c05d29c280a87bb28c89d6b24093f5784fce486e7710a78e"
    sha256                               arm64_sequoia: "536a0f58a5a6df2b1f48e43373bdeac5ac9e1b5464fdc361d15ad8b92cc7b699"
    sha256                               arm64_sonoma:  "c01be637d70875d157edf2c3ba4dfd36c10e957a61d7541a1998e0a3ecf510fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21d4da61f02747819491821b64838603e751418557db24c90af15d7522693697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b7f9d25015bb598c20c3ff24aa77f071b98efcd24dd557ed00af2f727124486"
  end

  depends_on "typescript" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-use --version")

    (testpath/"tsconfig.json").write <<~JSON
      {
        "compilerOptions": {
          "target": "ES2020",
          "module": "commonjs",
          "lib": ["ES2020"],
          "outDir": "./dist",
          "rootDir": "./src",
          "strict": true,
          "esModuleInterop": true,
          "skipLibCheck": true,
          "forceConsistentCasingInFileNames": true
        },
        "include": ["src/**/*"],
        "exclude": ["node_modules"]
      }
    JSON

    (testpath/"src/index.ts").write <<~TYPESCRIPT
      export const hello = (): string => "Hello from mcp-use";
    TYPESCRIPT

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-mcp-use",
        "version": "1.0.0",
        "description": "Test project for mcp-use",
        "main": "dist/index.js",
        "scripts": {
          "build": "tsc"
        },
        "devDependencies": {
          "typescript": "^5.0.0"
        }
      }
    JSON

    system "npm", "install", *std_npm_args(prefix: false)
    system bin/"mcp-use", "build"

    assert_path_exists testpath/"dist/index.js"
    assert_match "Hello from mcp-use", (testpath/"dist/index.js").read
  end
end
