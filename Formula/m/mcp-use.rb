class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.3.0.tgz"
  sha256 "86c737ff2b293edc9b4af03995569273b5cfd6418eaacee689d0be71842c2237"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "dbb3501304497780789067b8d027205fe6cb70c4cff11ef0b4625008accccc8d"
    sha256                               arm64_sequoia: "640106482f3a10bf4fe7d82b1e6c9059b9d0dc1dbce7ad12862c0a0da2c2eda4"
    sha256                               arm64_sonoma:  "b21325cfa0942734edae78d7692c743a28d5397f6fbd830b6956a023236fd524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e150d315d8a71b2daf5707ee40c1cfd68dcf77128e56d6bf037828ad2b70e3c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ec6b207cb740dd9a4eb0e7fd2b201c35802e7d57c24ec073463fbaf580302a"
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
