class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.4.4.tgz"
  sha256 "b4726c92d6aef8e4345280a7e81c7e8f5e0b5b109f4bba07c55267129452a7a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "e0531fad902357586fef971365dcc75ba1d4fed6b9ef5c45738715562b852a48"
    sha256                               arm64_sequoia: "7c9a4cc04df6ea404c53e4354966fcc93182dade585e65272a422e847edb377c"
    sha256                               arm64_sonoma:  "b6b1539ff533b91215e963ddbbfe6a51f710f99811d580888d98ac2a899d35fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b99a9c6ac663b7aa8357ce958cbe3258c5e5f24d5c6d31f59650dfc97e514e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bcde380bd8ae39104b26e230562ab5fc2f1dc39e8ab1242ec24c29d07799221"
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
