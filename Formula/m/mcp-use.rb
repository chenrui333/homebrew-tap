class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.17.0.tgz"
  sha256 "ea6b096d30c2e2705127bec9fc522ab51d09de3a942c127d7b99498a19078945"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "86962a657df4f93d871e3854ffff1a866d0abbc862daed9423ad2eb1a2c4037a"
    sha256                               arm64_sequoia: "9e113e3939597a7af1756fe2d41e7ef2fbb6fb6203ddd3fe25164690a0d0766f"
    sha256                               arm64_sonoma:  "d38fc70aa248577e198d2ebae9f8ba6bca42994057ac3aaff1b54d2b7c2df9bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d962c88122104ab6932646101d07e606c14ab1e5018af8655a44bef7a0c1e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c3b820106f04419c3ac8554da16617967d54ef1e37cc174ae09ba39572b8b92"
  end

  depends_on "typescript" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    if OS.linux?
      # ext-apps vendors Bun platform packages; keep glibc builds but remove
      # musl variants to satisfy linkage checks on Homebrew Linux runners.
      libexec.glob("lib/node_modules/**/@oven/bun-linux-*-musl*").each(&:rmtree)
    end

    bin.install_symlink libexec.glob("bin/*")
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
