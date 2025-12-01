class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.4.5.tgz"
  sha256 "d877852465b4d79ad05a825519b14e883fe1086a8c85e52a9ffe9a705d660e91"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "382bd30334d3c4d7f3779e37a78d107a5aefb9b2db16fbf5d10aab91d9a2eac1"
    sha256 cellar: :any,                 arm64_sequoia: "6884f6817cebfced77c6e9feda73539a7fb54d5221a45e2da76b5bfd4decf6e1"
    sha256 cellar: :any,                 arm64_sonoma:  "6884f6817cebfced77c6e9feda73539a7fb54d5221a45e2da76b5bfd4decf6e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39407bec051164da3afa0809dfec242e0fa0c22d4ece678a35c8232fdbee4752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f442c1506bcce045087b9ecdf6995ec65ca0633817b025a6f5290d84290d2ff"
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
