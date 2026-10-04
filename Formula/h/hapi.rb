class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://github.com/tiann/hapi/archive/refs/tags/v0.30.7.tar.gz"
  sha256 "064bf74ba4539372c3e2784b8ea5edb2501090604628dfcf27b2bdca516b145a"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "3071489660565a07d3f7692cd41a9d4ce356ace8f3437fe1c06fc6ab88d36efd"
    sha256 arm64_sequoia: "98a15d7566243bc3b9fdd64a6dc0d6212554df0a2284f4c7fa468f0f75099838"
    sha256 arm64_linux:   "ca5fab9acfb36650eb46af29a5cd65b23f21128c25bb22c3b2898d448f982e51"
    sha256 x86_64_linux:  "b2fd6d8cbf7a52b321045827ff8a64ec16991bec21a041c6c7ff443b07128701"
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "difftastic"
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@78"
  end

  resource "tunwg" do
    url "https://github.com/tiann/tunwg/archive/refs/tags/v26.08.03+122a6d0.tar.gz"
    sha256 "a724a5c3d2f88b40fbe42d09090266cdc8551a55ccb0cf19e450f63613cc8393"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts",
           "--cache-dir", buildpath/"bun-cache"
    resource("tunwg").stage do
      system "go", "mod", "download"
    end
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.start_with?("icu4c") }.to_formula
      odie "Update icu4c dependency!" if bun_icu.name != "icu4c@78"
    end

    # Homebrew retains the workspace and node_modules populated by fetch.
    resource("tunwg").stage do
      system "go", "build", *std_go_args(output: libexec/"tunwg", ldflags: "-s -w"), "./tunwg"
    end

    # Use brewed helpers instead of embedding upstream's prebuilt archives.
    %w[ripgrep difftastic].each do |tool|
      executable = (tool == "ripgrep") ? "rg" : "difft"
      inreplace "cli/src/modules/#{tool}/index.ts", /function getBinaryPath\(\): string \{.*?^\}/m,
                "function getBinaryPath(): string { return '#{formula_opt_bin(tool)/executable}'; }"
    end
    %w[cli/src/runtime/assets.ts hub/src/tunnel/tunnelManager.ts].each do |path|
      inreplace path, /function getTunwgPath\(\): string \{.*?^\}/m,
                "function getTunwgPath(): string { return '#{opt_libexec}/tunwg'; }"
    end
    inreplace "cli/src/runtime/assets.ts",
              /export async function ensureRuntimeAssets\(\): Promise<void> \{.*?^\}/m,
              "export async function ensureRuntimeAssets(): Promise<void> {}"

    system "bun", "run", "build:web"
    cd "hub" do
      system "bun", "run", "generate:embedded-web-assets"
    end
    cd "cli" do
      system "bun", "build", "src/bootstrap.ts", "--compile", "--no-compile-autoload-dotenv",
             "--no-compile-autoload-bunfig", "--outfile", bin/"hapi"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
    assert_match "specify one of port to forward", shell_output("#{libexec}/tunwg 2>&1", 1)
  end
end
