class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.2.2.tgz"
  sha256 "0fc409ea25207658429e45d189626819b90d1cb24aca78ef207286a50cf75515"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "84127c3707771a86b4e445fa1f1039fa4f55182fa24930f04e59884b2c2e23ec"
    sha256                               arm64_sequoia: "56d9a0dbffeb56882fcc7ebc168b27c5ad426165cdfa1c903da6d76a6afeac02"
    sha256                               arm64_sonoma:  "1553fa83f173e566508a53d3c0bb7a4996a98ed2f240bebeb582c8495a08a968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a40385b98f31f1a514a5b4f46c24fab25fb9e5d941a6024d8f2d03174ebcd578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a014a0046f4b597d2f4eb0d052366e4210d3acf6c035647dc52fc8f126f76646"
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
