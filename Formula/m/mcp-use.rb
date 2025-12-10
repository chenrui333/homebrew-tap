class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.5.6.tgz"
  sha256 "f2ed4bf03c0dc6e6f4978e24ed5f7efc6b078d3a279b9b50ece9fb7458309ea6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9d9d30dd3da72256e730ca75ef32305507743b9ad70fd302cce6d3444227313a"
    sha256 cellar: :any,                 arm64_sequoia: "63737613506a24c0472f2198bcc2234023adfcd29892c1d188854a4bc0744d95"
    sha256 cellar: :any,                 arm64_sonoma:  "63737613506a24c0472f2198bcc2234023adfcd29892c1d188854a4bc0744d95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c81b29dc0385f7cf9dbb8d4b3c9994c390a7762abba6bca9e7f176fd5d97a061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c79dad9db15e0dd7815b0119884e44d0b2c0f4a96534762274df21fcd8c1e52"
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
