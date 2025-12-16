class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.6.0.tgz"
  sha256 "007a063a9ce8ff45fb66caa253ec80ad3df3da2688148732f7a72209183b5f7e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d8ed1e3c9e7bc6ba720fca34436aa59080bf06ead622789e324a62211ed920f5"
    sha256 cellar: :any,                 arm64_sequoia: "50472791e397208a543aebea4470097b0e8abd1349c7a24a5b701d0d61aac7e6"
    sha256 cellar: :any,                 arm64_sonoma:  "50472791e397208a543aebea4470097b0e8abd1349c7a24a5b701d0d61aac7e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f760652bb620fcc7096c8bed1ae4207063206f6b440a33e08cab7352c55e0b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8834c7379f3c7c6b86b05f880ad6100c88fc7215238cfb74fc9061a4c570ec3"
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
