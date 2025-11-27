class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.4.1.tgz"
  sha256 "05a9d4f0a89d3d6109ddc9b2a824ec2a4cc815427a11a7d433f822ef5a6ec2b7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "4f7c3e88752e1506ae65cac18a4c251a510822cf1e38e304d54e5ca482e9a46f"
    sha256                               arm64_sequoia: "e394e374c5c89490a09937ee122e213f2c235f4899e5882a0a2b39421db1636a"
    sha256                               arm64_sonoma:  "a115b8c01bf35193a048cefe0d9b364e9189b5dc35e04d87814e9e63480536d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "affebec15a5d72fdf5d6ad6278d26d6e877333ee92223081dc25548d9bd2bd2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dcdd6a6f56c967267385f2722e03f8558db21d8beb1c40b0384e20858764c6c"
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
