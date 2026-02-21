class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.15.3.tgz"
  sha256 "3169247b68176bf489eea00f1e8e5933f196d922a69667096a2c880bb3be90ef"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8e8a37575f91edbe00ce879318e5577b89c5c5f835d78c9d6849e54a5671214b"
    sha256 cellar: :any,                 arm64_sequoia: "5657de565a9e01aa18af5313c7c5d8f522bf710776217304e8cd009e13df3fa9"
    sha256 cellar: :any,                 arm64_sonoma:  "5657de565a9e01aa18af5313c7c5d8f522bf710776217304e8cd009e13df3fa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea3636bb13367f98aaef1b99c2673deda51da2b0e1b18253b58be8b7efcbc9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d017796ed51b58153ed5330ae132e439b5db939342097a7f8a57391033adf30"
  end

  depends_on "typescript" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
