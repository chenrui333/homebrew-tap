class McpUse < Formula
  desc "CLI for mcp-use"
  homepage "https://mcp-use.com/"
  url "https://registry.npmjs.org/@mcp-use/cli/-/cli-2.13.8.tgz"
  sha256 "7728a76e6dc5df5a0c734142f69f67245a6684c0dcb83e219d02798190330083"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8e8a37575f91edbe00ce879318e5577b89c5c5f835d78c9d6849e54a5671214b"
    sha256 cellar: :any,                 arm64_sequoia: "5657de565a9e01aa18af5313c7c5d8f522bf710776217304e8cd009e13df3fa9"
    sha256 cellar: :any,                 arm64_sonoma:  "5657de565a9e01aa18af5313c7c5d8f522bf710776217304e8cd009e13df3fa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea3636bb13367f98aaef1b99c2673deda51da2b0e1b18253b58be8b7efcbc9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d017796ed51b58153ed5330ae132e439b5db939342097a7f8a57391033adf30"
  end

  depends_on "typescript" => :test
  depends_on "node"

  resource "mcp-use-lib" do
    url "https://registry.npmjs.org/mcp-use/-/mcp-use-1.19.0.tgz"
    sha256 "32e137861910b5927c77b95d15da0c588ac7d9600cc1f38370fb03fb95ae25f7"
  end

  def install
    package = libexec/"lib/node_modules/@mcp-use/cli"
    package.install Dir["*"]

    (deps = buildpath/"deps").mkpath
    (deps/"package.json").write <<~JSON
      {"name":"mcp-use-homebrew-deps","version":"1.0.0"}
    JSON

    install_packages = %w[
      zod
      commander
      dotenv
      vite-plugin-singlefile
      @modelcontextprotocol/sdk
      hono
      jose
      @modelcontextprotocol/ext-apps
      @mcp-ui/server
    ]

    cd deps do
      install_packages.each do |npm_package|
        system "npm", "install", npm_package, *std_npm_args(prefix: false)
      end
    end

    (package/"node_modules").mkpath
    cp_r Dir[deps/"node_modules/*"], package/"node_modules"

    resource("mcp-use-lib").stage do
      (package/"node_modules/mcp-use").install Dir["*"]
    end

    (package/"dist/index.cjs").chmod 0755
    bin.install_symlink package/"dist/index.cjs" => "mcp-use"
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
