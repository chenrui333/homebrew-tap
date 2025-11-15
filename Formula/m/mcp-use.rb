class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.2.0.tgz"
  sha256 "b623c8a4b87ed43e9c9e95a39363192935ff0f64d84eb8a54f5af35037405d83"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "ed3bf20e0da79dbfd0604b7ba0db42d9e39ac0bb66f6f685f86a86abb2afaa87"
    sha256                               arm64_sequoia: "94491c8ad7f511907a81ea2d938dc26da78212dd0f0c0b20e785c5f51a230ebc"
    sha256                               arm64_sonoma:  "03f8224b19f0bd82e3ddb91bb964c1596dacccf4e5ac56b3580403ae2b865cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffded93cc54bf90b209aa8fd6981e82a470220750fba72f15470468a4807591f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e19ec1c6b55e2ade543b391e481174e12f0bcf8473ea2d3f338a938e0a4774f"
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
