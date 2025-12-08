class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.5.0.tgz"
  sha256 "6ccdb3f846e59bd067372c104d6a26e82085768db00de3acc084ae58e4fa490b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0e6659f255528dd1d73aa51b8d3fea66fc640a424d81b86ce42d452f8da6447f"
    sha256 cellar: :any,                 arm64_sequoia: "6b59a465a34d0d779579985a257b13002d38ae2caa72cc769844feab5be59835"
    sha256 cellar: :any,                 arm64_sonoma:  "6b59a465a34d0d779579985a257b13002d38ae2caa72cc769844feab5be59835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a22292cab7ec03e320e1149240d40fe77627614b862b4ad764facad65666eaad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4212305471fd2f2cca1d529a56275965be95f971b2b895ef8cecf90d8725e208"
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
