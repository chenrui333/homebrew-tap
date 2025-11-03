class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.1.22.tgz"
  sha256 "ac4e1f36f5abdb411c7f02833379b0ccd1d202175286e935c57bb67048ea8eab"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "62ef7f5aa26a5460e146483bf3f8f2be6dd8e59fa016b97acdb014ce845df8ea"
    sha256                               arm64_sequoia: "313c1b97969ad65791cf79f00c6f852bc1cecf331f9cbaa0eeec94ece30b0a28"
    sha256                               arm64_sonoma:  "03b9bc195c1e4faab0f4ad7137b0c44eb2527eaf8628bb23699bd013f5d33b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a577b8dd52ced9bc7f38403ae47e7b58ccbf3cd6dd7c386e7afd5aa8e192c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c78ccdc46cfd6daaed5f42d49fad62b0217363af40b24f499b7c82a801429cbc"
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
