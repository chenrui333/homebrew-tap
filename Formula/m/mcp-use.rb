class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.1.23.tgz"
  sha256 "86dd39626a8e11267be729ab9ef81c2312afdae4db7aa55bb7670f9facaab183"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d2cb5aeeadd4f5aac78e7193312901601ea807be4cbf01a83ff2aabbfab65c73"
    sha256                               arm64_sequoia: "1e7df7bc3f190f3ff03697a1602c2cd4600473d2e860a49cf6531316cce01300"
    sha256                               arm64_sonoma:  "e968af35aeddc9b58808ff307d056f14df8a9fb169543d3ec8e675e1cbe34620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8afdb9f7a6284ed407690df2ad30d94ddb895ac50153b240ef90bfa467b8dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f69255b4197e1bccfec37fb5a999f443d84e649ad6569b2dab574b50a3332b31"
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
