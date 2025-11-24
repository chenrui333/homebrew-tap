class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.3.0.tgz"
  sha256 "86c737ff2b293edc9b4af03995569273b5cfd6418eaacee689d0be71842c2237"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "8284c8d7e70dae5658368334ea285ec8b96e1098b26bb3696622a563e360b168"
    sha256                               arm64_sequoia: "2ba1c6ddf4f3162852130501affe7a1b03412f4b418c61886c72b765ec5f0237"
    sha256                               arm64_sonoma:  "1ed413c96c22bc1930263fcaba61031534a3b541cac15c183ea2d5567dfecb3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea352d00bd5666fa9e6744fbd09b00cf079699d81f547531309973ff93d2816f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa916c79c46aa75cd7d606c7084bcbf3db2dbfcea75d98ce716010431b8fced"
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
