class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.4.8.tgz"
  sha256 "a67dffe3bee1f2bef09a6f3bb66ee644fd566918b3853521c4757a3abc8da088"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5a29e545d77693e8e648dd5bc10508a85425992a57a3c3b5dfa5765f21b91146"
    sha256 cellar: :any,                 arm64_sequoia: "40b2463fed1cbbebb4c737cc4cc924894894cbabfa3105f74891c8fe5777047f"
    sha256 cellar: :any,                 arm64_sonoma:  "40b2463fed1cbbebb4c737cc4cc924894894cbabfa3105f74891c8fe5777047f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "124fce62acbc0e730db7cefa16eb699afa1bdd335b94a071e55fcff89efe16ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2849d7541eafa3960348f7ee7efe8364e79285bc968afbdc05f4885ec064cc6"
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
