class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.2.1.tgz"
  sha256 "3b8696cc184720205b614573a40375fba429008a3770ce81fc26cf7baa7aee4f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a891767def9b4460a1c97d0d9662a795be2ec0307ac37a09397b13b5015bbb3c"
    sha256                               arm64_sequoia: "25f767412fd1cd935a36f1473a2db6431d21e4cad14007ffec7fbb176270c434"
    sha256                               arm64_sonoma:  "4877b04a05e96211cd7ad48be0541a486869e675ec8961153dce161dc9fa5e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffa80423928a761498ae6b9ea6610a173a263a3aec56b9573159fdacece54e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02edb4ad2d2a93c2bd4a74466c9c77727c59022e0ab56cac78a35f56f5d442f5"
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
