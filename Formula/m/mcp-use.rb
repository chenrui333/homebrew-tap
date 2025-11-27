class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.4.2.tgz"
  sha256 "f4930a8355698f8f9ce8d59ddddd0d32abc036426c815aa962459b588d553880"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "b0c71185dbb828300967f56730c64d3c58672fe8699b54f065f5ef827be09223"
    sha256                               arm64_sequoia: "fa2b2854204b31c52cd7b6c8a590cb0fcc7559d79e2335637e8b4923c1d0546e"
    sha256                               arm64_sonoma:  "ac3eac1b54921331dd962c223f50534e08b33214967acf2a9a9a6cc2593f8724"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d1d3e0e0bf6e82b9ff0c710f94d82b7f3765d336bca7a4508749a0e3685ea25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f00742e43ffb9c75e14cf864e308da1049d6f0f874066c40fc721e948bd623"
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
