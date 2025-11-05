class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.1.24.tgz"
  sha256 "8f1afe127b8c7d960ec4f01559ad14b6b37a2efb5bfdf03bacfd0fe094afd6f7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "06665fb78a1352d179824f7dfcf073b6673bef254302ec23eae237fdd59de973"
    sha256                               arm64_sequoia: "ecc8e22adb88999f3df8d27fccb28d9174964b0367c9e96e7af5a0a2b70e0c44"
    sha256                               arm64_sonoma:  "f4a436b225d5de21bcdf736e3b8b33bf7142640b656975b977e864fd261723da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f8cb2d364b50b2f3a3a078d95255bf82566571bff42eb9763f88683d1c4110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62c5a81dc5b6ba9bb9e85bb9e0599a8de0638ac4801a53338ec520ac138b457"
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
