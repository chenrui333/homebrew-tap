class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.5.5.tgz"
  sha256 "165c3d174bc2b6bdfd693f74622e550530b0f8c53cda5016975dd6fdeae478d0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f1d6a8fd756159a7806297effc4798f06332c22177692c692fec6fa34c9f1a91"
    sha256 cellar: :any,                 arm64_sequoia: "c2654cf73090ea5ed1bda8a6390c73e965747b97682096efc7bbce829fed0ddc"
    sha256 cellar: :any,                 arm64_sonoma:  "c2654cf73090ea5ed1bda8a6390c73e965747b97682096efc7bbce829fed0ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6a258badac910850833d7a0b2196e2889a7b0f890ff96f8a613fdb0f2163541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f0232acf52a472c25d02bc960713fe740128f2b3fbf33560aa9c1136006f40"
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
