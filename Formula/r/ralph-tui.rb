class RalphTui < Formula
  desc "AI agent loop orchestrator"
  homepage "https://ralph-tui.com"
  url "https://github.com/subsy/ralph-tui/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "aa532de1fab2a8e7ebb0cf575e26fdf2a4ad5d3454459a7e7487f1912ec1dc5a"
  license "MIT"
  revision 1
  head "https://github.com/subsy/ralph-tui.git", branch: "main"

  depends_on "oven-sh/bun/bun" => :build

  def install
    bun = Formula["oven-sh/bun/bun"].opt_bin/"bun"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    libopentui = "libopentui.#{OS.mac? ? "dylib" : "so"}"
    opentui_dir = buildpath/"node_modules/@opentui/core-#{platform}-#{arch}"
    webgpu_dir = buildpath/"node_modules/bun-webgpu-#{platform}-#{arch}"
    notifier_dir = buildpath/"node_modules/node-notifier/vendor/mac.noindex"

    system bun, "install", "--frozen-lockfile"
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
