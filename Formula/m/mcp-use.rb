class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.4.5.tgz"
  sha256 "d877852465b4d79ad05a825519b14e883fe1086a8c85e52a9ffe9a705d660e91"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b09cb6b809e22b23e07e8b95dd536e3b46d2f9603825671ad3d9e72512e35dde"
    sha256 cellar: :any,                 arm64_sequoia: "6cc4973b2681b8031a97c4703c13302582e8f20e35bb4ff7ebca70dcb08a4168"
    sha256 cellar: :any,                 arm64_sonoma:  "6cc4973b2681b8031a97c4703c13302582e8f20e35bb4ff7ebca70dcb08a4168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c6cfbcc91e9b65c4f7e46169a90b62c14076eb7a82f491ab474e27bd01b0ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab97e8ffddbf68d7a303f6556d2a4d53c3233a037de6a70de9dc0bbc7cd13f1d"
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
