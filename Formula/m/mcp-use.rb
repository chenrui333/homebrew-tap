class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.6.0.tgz"
  sha256 "007a063a9ce8ff45fb66caa253ec80ad3df3da2688148732f7a72209183b5f7e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ab45ea2fc776de8829759197a38a8f6521ab0f8dfd7eae22593af1a787ac0037"
    sha256 cellar: :any,                 arm64_sequoia: "384de4546a14663b880636dd24300f4ed9b049e7c986a9feb21fadc89f3b5132"
    sha256 cellar: :any,                 arm64_sonoma:  "384de4546a14663b880636dd24300f4ed9b049e7c986a9feb21fadc89f3b5132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c2e76998ef067a4f1f5157eaaf3e362a3deb59eed38076882a1883d5b8f85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e71af5cc1f88a0bb7bf59fd2559c6570b768467b52e6ced099d0f1de6815c894"
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
