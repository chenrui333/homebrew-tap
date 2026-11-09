class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://github.com/tiann/hapi/archive/refs/tags/v0.30.7.tar.gz"
  sha256 "064bf74ba4539372c3e2784b8ea5edb2501090604628dfcf27b2bdca516b145a"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "f7aa0d0c96ab85ffdb9bcb9bcc2c5d1c1abb30f4fdce89af794ee88921260447"
    sha256 arm64_sequoia: "11c9d24be1accc26291433a26cb3fe60dc1be4121055b1683eef4400705a1931"
    sha256 arm64_linux:   "4b3426838e13fc1bf62fab5fdd0a542d33d9278967f8181c5a261161e3106248"
    sha256 x86_64_linux:  "021a343b35827ff35d0c5ba89be84cac421a432a3f2e4d39d84b5d69efd68dd3"
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "difftastic"
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@79"
  end

  resource "tunwg" do
    url "https://github.com/tiann/tunwg/archive/refs/tags/v26.08.03+122a6d0.tar.gz"
    sha256 "a724a5c3d2f88b40fbe42d09090266cdc8551a55ccb0cf19e450f63613cc8393"
  end

  # Restore web's missing Playwright 1.60.0 lock entries without unrelated dependency upgrades.
  # Entries from https://github.com/tiann/hapi/commit/c258a2279e900bbbd02c532325cb824af59e2efa
  patch :DATA

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
      odie "Update icu4c dependency!" if bun_icu.name != "icu4c@79"
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
    assert_match "specify one of port to forward", shell_output("#{libexec}/tunwg 2>&1", 1)
  end
end

__END__
diff --git a/bun.lock b/bun.lock
--- a/bun.lock
+++ b/bun.lock
@@ -3766,4 +3766,6 @@
     "get-intrinsic/hasown": ["hasown@2.0.2", "", { "dependencies": { "function-bind": "^1.1.2" } }, "sha512-0hJU9SCPvmMzIBdZFqNPXWa6dqh7WdH0cII9y+CyS8rG3nL48Bclra9HmKhVVUHyPWNH5Y7xDwAB7bfgSjkUMQ=="],
 
+    "hapi-web/@playwright/test": ["@playwright/test@1.60.0", "", { "dependencies": { "playwright": "1.60.0" }, "bin": { "playwright": "cli.js" } }, "sha512-O71yZIbAh/PxDMNGns37GHBIfrVkEVyn+AXyIa5dOTfb4/xNvRWV+Vv/NMbNCtODB/pO7vLlF2OTmMVLhmr7Ag=="],
+
     "hapi-website/@types/node": ["@types/node@24.10.4", "", { "dependencies": { "undici-types": "~7.16.0" } }, "sha512-vnDVpYPMzs4wunl27jHrfmwojOGKya0xyM3sH+UE5iv5uPS6vX7UIoh6m+vQc5LGBq52HBKPIn/zcSZVzeDEZg=="],
 
@@ -4178,4 +4180,6 @@
     "form-data/mime-types/mime-db": ["mime-db@1.52.0", "", {}, "sha512-sPU4uV7dYlvtWJxwwxHD0PuihVNiE7TyAbQ5SWxDCB9mUYvOgroQOwYQQOKPJ8CIbE+1ETVlOoK1UC2nU3gYvg=="],
 
+    "hapi-web/@playwright/test/playwright": ["playwright@1.60.0", "", { "dependencies": { "playwright-core": "1.60.0" }, "optionalDependencies": { "fsevents": "2.3.2" }, "bin": { "playwright": "cli.js" } }, "sha512-hheHdokM8cdqCb0lcE3s+zT4t4W+vvjpGxsZlDnikarzx8tSzMebh3UiFtgqwFwnTnjYQcsyMF8ei2mCO/tpeA=="],
+
     "hapi-website/@types/node/undici-types": ["undici-types@7.16.0", "", {}, "sha512-Zz+aZWSj8LE6zoxD+xrjh4VfkIG8Ya6LvYkZqtUQGJPZjYl53ypCaUwWqo7eI0x66KBGeRo+mlBEkMSeSZ38Nw=="],
 
@@ -4526,2 +4530,4 @@
     "@vitejs/plugin-vue/vite/esbuild/@esbuild/win32-x64": ["@esbuild/win32-x64@0.21.5", "", { "os": "win32", "cpu": "x64" }, "sha512-tQd/1efJuzPC6rCFwEvLtci/xNFcTZknmXs98FYDfGE4wP9ClFV98nyKrzJKVPMhdDnjzLhdUyMX4PsQAPjwIw=="],
+
+    "hapi-web/@playwright/test/playwright/playwright-core": ["playwright-core@1.60.0", "", { "bin": { "playwright-core": "cli.js" } }, "sha512-9bW6zvX/m0lEbgTKJ6YppOKx8H3VOPBMOCFh2irXFOT4BbHgrx5hPjwJYLT40Lu+4qtD36qKc/Hn56StUW57IA=="],
 
