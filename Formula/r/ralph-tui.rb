class RalphTui < Formula
  desc "AI agent loop orchestrator"
  homepage "https://ralph-tui.com"
  url "https://github.com/subsy/ralph-tui/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2acc8812f65a6a5fdede1c46f73671435afbadddc83bce0a6b52ed0a0a11bd9a"
  license "MIT"
  head "https://github.com/subsy/ralph-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97ae222b6a69ba53e8319cab14141817db5403960f2fde3650e0a8ed1b090916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb98ff401d356579f93dd4195c15f76d5d5e35520cd499241d858f7c793b076e"
  end

  depends_on "bun"

  deny_network_access!

  def fetch
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--cache-dir", buildpath/"bun-cache"
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    libopentui = "libopentui.#{OS.mac? ? "dylib" : "so"}"
    opentui_dir = buildpath/"node_modules/@opentui/core-#{platform}-#{arch}"
    webgpu_dir = buildpath/"node_modules/bun-webgpu-#{platform}-#{arch}"
    notifier_dir = buildpath/"node_modules/node-notifier/vendor/mac.noindex"

    system bun, "run", "build"

    mv opentui_dir/libopentui, opentui_dir/"#{libopentui}.raw"
    system "gzip", "-9", opentui_dir/"#{libopentui}.raw"
    mv opentui_dir/"#{libopentui}.raw.gz", opentui_dir/"#{libopentui}.gz"
    rm opentui_dir/"index.ts"
    (opentui_dir/"index.ts").write <<~TS
      import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
      import { dirname, join } from "node:path";
      import { fileURLToPath } from "node:url";
      import { gunzipSync } from "node:zlib";

      const moduleDir = dirname(fileURLToPath(import.meta.url));
      const archivePath = join(moduleDir, "#{libopentui}.gz");
      const cacheRoot = process.env.XDG_CACHE_HOME || join(process.env.HOME || moduleDir, ".cache");
      const cacheDir = join(cacheRoot, "ralph-tui", "opentui");
      const dylibPath = join(cacheDir, "#{libopentui}");

      if (!existsSync(dylibPath)) {
        mkdirSync(cacheDir, { recursive: true });
        writeFileSync(dylibPath, gunzipSync(readFileSync(archivePath)));
      }

      export default dylibPath;
    TS
    rm_r webgpu_dir if webgpu_dir.exist?
    rm_r notifier_dir if notifier_dir.exist?

    libexec.install "dist", "node_modules", "package.json"

    rm bin/"ralph-tui" if (bin/"ralph-tui").exist?
    (bin/"ralph-tui").write <<~SHELL
      #!/bin/bash
      exec "#{bun}" "#{libexec}/dist/cli.js" "$@"
    SHELL
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph-tui --version")
    output = shell_output("#{bin}/ralph-tui status --json --cwd #{testpath} 2>&1", 2)
    assert_match "\"status\": \"no-session\"", output
  end
end
