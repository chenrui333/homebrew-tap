class OmoAi < Formula
  desc "Standalone Oh My OpenAgent coding agent, Senpi edition"
  homepage "https://github.com/code-yeongyu/oh-my-openagent"
  url "https://github.com/code-yeongyu/oh-my-openagent/archive/refs/tags/v5.1.70.tar.gz"
  sha256 "f0217346c919f2a61411ff476a490d94a60ed4accb241213c405051ccff20a42"
  # The launcher/engine are MIT; the bundled OpenAgent plugin is SUL-1.0.
  license :cannot_represent
  head "https://github.com/code-yeongyu/oh-my-openagent.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "4d84193ceb19e15350adf740b668287f16661ae161409f6fef79d1d8ffc5eb1a"
    sha256 cellar: :any, arm64_sequoia: "5f925075bc0b02a98fbd68cf87ac641b0acbc182a311baaa60867072b2589eaf"
    sha256 cellar: :any, arm64_linux:   "22579b9241d036af293838ab73c45b615eca90692960229b91bbd70afeb450d1"
    sha256 cellar: :any, x86_64_linux:  "8b832f2a5dc9724316c3a2e3601ef4c64fe2430325b7001436fcb968b7b374c8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zig@0.16" => :build
  depends_on "bun"
  depends_on "fd"
  depends_on "node"
  depends_on "ripgrep"

  on_linux do
    depends_on "libseccomp" => :build
    depends_on "python@3.15" => :build
    depends_on "bubblewrap"
    depends_on "libxcb"
    depends_on "socat"
  end

  resource "opentui-native" do
    url "https://github.com/anomalyco/opentui/archive/6b9863ea7c5fae22bfebb23c242ddcc4c2b0aa0e.tar.gz"
    sha256 "6f3854e067fd34abc31c1d3360a00ff65ca13df734b34dc09b23137dec5c4e86"
  end

  # npm provenance maps @code-yeongyu/senpi@2026.11.5-1 to this immutable source commit.
  resource "senpi" do
    url "https://github.com/code-yeongyu/senpi/archive/c130b2d8b99ed0c3dc42a2c5b3a49959aa5ce018.tar.gz"
    sha256 "3ee1e44a1bcb3db7b34a5e1e3de4c731d9a3d3799786cc6370f3dfa38cb4a80f"
  end

  resource "sandbox-helper-sources" do
    url "https://github.com/anthropics/sandbox-runtime/archive/refs/tags/v0.0.73.tar.gz"
    sha256 "b4b61ce8ed2038e00771e4e3ae733389ea2e41f4821d17926272b603a57393a5"
  end

  resource "designpowers" do
    url "https://github.com/Owl-Listener/designpowers/archive/cb00757da9d554591fa78d27aa1854d60a05c4f7.tar.gz"
    sha256 "03c0b5c9e3a143d577812a1d3eac36dfba4104705b8ac79295ad279beb4a5fd8"
  end

  resource "open-design" do
    url "https://github.com/nexu-io/open-design/archive/6afe7eae156bfa29251a51fd0636649c257f7444.tar.gz"
    sha256 "6bf5c781fbc3bd33336ba0ed0e27fec9348c528da833d4d34cd38cc04d4b9f6e"
  end

  resource "taste-skill" do
    url "https://github.com/Leonxlnx/taste-skill/archive/b17742737e796305d829b3ad39eda3add0d79060.tar.gz"
    sha256 "326be442c7a76de4b6013dbca938a182b3c604c402b293da0d1481cff33574b7"
  end

  resource "ui-ux-pro-max" do
    url "https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/archive/f32d6a61cdf0bfd57404c45854583fd19ff95088.tar.gz"
    sha256 "414f0fb84f94a470e5af202ab4b0eb643e61f9f4b7a81ea4ac5edfcf1e282169"
  end

  deny_network_access!

  def fetch
    bun = formula_opt_bin("bun")/"bun"
    system bun, "install", "--frozen-lockfile", "--ignore-scripts"
    cd "packages/lsp-daemon" do
      system "npm", "ci", "--ignore-scripts", "--no-audit", "--no-fund"
    end
    resource("senpi").stage(buildpath/"senpi")
    cd "senpi" do
      system bun, "install", "--frozen-lockfile", "--ignore-scripts"
      system "cargo", "fetch", *std_cargo_fetch_args
    end
    resource("opentui-native").stage(buildpath/"opentui-native")
    cd "opentui-native/packages/native" do
      system "sh", "scripts/prepare-zig-deps.sh"
      system formula_opt_bin("zig@0.16")/"zig", "build", "--fetch"
    end
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    host = "#{platform}-#{arch}"
    # Compile the real native core, including audio/Yoga integrations, with relocatable Mach-O padding.
    native_name = OS.mac? ? "libopentui.dylib" : "libopentui.so"
    native_target = "#{Hardware::CPU.arm? ? "aarch64" : "x86_64"}-#{OS.mac? ? "macos" : "linux"}"
    cd "opentui-native/packages/native" do
      inreplace "build.zig", "if (target.result.os.tag == .linux and optimize != .Debug)",
                "if (target.result.os.tag == .macos) lib.headerpad_max_install_names = true;\n    " \
                "if (target.result.os.tag == .linux and optimize != .Debug)"
      system formula_opt_bin("zig@0.16")/"zig", "build", "-Doptimize=ReleaseFast", "-j#{ENV.make_jobs}"
      (libexec/"opentui").install "lib/#{native_target}/#{native_name}"
    end
    buildpath.glob("**/node_modules/@opentui/core-*", File::FNM_DOTMATCH).each do |pkg|
      next unless pkg.exist?

      if pkg.basename.to_s == "core-#{host}"
        rm pkg/native_name
        ln_s libexec/"opentui"/native_name, pkg/native_name
      else
        rm_r pkg
      end
    end
    # Claude Code is an optional external integration, not a source-built part of this package.
    # Senpi already falls back to CLAUDE_CODE_EXECUTABLE or the user's claude on PATH.
    rm_r buildpath.glob("**/node_modules/@anthropic-ai/claude-agent-sdk-{darwin,linux,win32}-*")
    rm_r buildpath.glob("**/node_modules/.bun/@anthropic-ai+claude-agent-sdk-{darwin,linux,win32}-*@*")
    cd "senpi" do
      ENV["CARGO_NET_OFFLINE"] = "true"
      # Both NAPI packages expose only cdylib/rlib targets, not installable executables.
      system "cargo", "build", "--release", "--locked", "--lib", "-p", "senpi-pty", "-p", "senpi-grep"
      extension = OS.mac? ? "dylib" : "so"
      pty = buildpath/"senpi/packages/pty/native/prebuilds"
      grep = buildpath/"senpi/packages/coding-agent/native/prebuilds"
      rm_r pty
      rm_r grep if grep.exist?
      (pty/host).mkpath
      (grep/host).mkpath
      cp "target/release/libsenpi_pty.#{extension}", pty/host/"senpi_pty.#{host}.node"
      cp "target/release/libsenpi_grep.#{extension}", grep/host/"senpi_grep.#{host}.node"
      if OS.mac?
        # Use Homebrew's selected SDK for framework lookup too, not xcrun's newer default SDK.
        with_env("SDKROOT" => ENV.fetch("HOMEBREW_SDKROOT")) do
          system "bash", "packages/tui/native/darwin/build.sh"
        end
      else
        system "bash", "packages/tui/native/linux/build.sh"
      end
      buildpath.glob("senpi/packages/tui/native/*/prebuilds/*").each do |dir|
        rm_r dir if dir.basename.to_s != host
      end
      system "node", "scripts/build-all.mjs", "--pm", "bun"
      rm_r "target"
    end

    # Replace the registry engine with our source-built tree, including workspace-local imports.
    engine = buildpath/"senpi/packages/coding-agent"
    workspace = (buildpath/"senpi/packages").children.select { |dir| (dir/"package.json").file? }
    workspace.each do |dir|
      name = JSON.parse((dir/"package.json").read).fetch("name")
      names = [name]
      names << "@code-yeongyu/senpi-pty" if dir.basename.to_s == "pty"
      names << "@code-yeongyu/senpi-tui" if dir.basename.to_s == "tui"
      names.each do |package|
        buildpath.glob("**/node_modules/#{package}", File::FNM_DOTMATCH).each do |entry|
          rm_r entry
          ln_s dir.relative_path_from(entry.dirname), entry
        end
      end
    end
    resources.reject { |r| %w[senpi opentui-native sandbox-helper-sources].include?(r.name) }.each do |r|
      r.stage buildpath/"packages/shared-skills/upstreams/#{r.name}"
    end
    # Exact gitlink source resources are already staged; no mutable git checkout is needed.
    inreplace "packages/omo-codex/plugin/scripts/materialize-shared-upstreams.mjs",
              "await initSubmodules({ strict });", "// Pinned submodules staged by Homebrew."
    inreplace "package.json", "npm --prefix packages/lsp-daemon ci && ", ""
    system bun, "run", "build:materialize-frontend"
    system bun, "run", "build:lsp-daemon"
    system bun, "run", "build:ast-grep-mcp"
    system bun, "script/build-service-auth.ts"
    system bun, "script/build-reflection-lock.ts"
    system bun, "run", "build:omo-native"
    ENV["OMO_SENPI_PATCH_ROOT"] = engine
    system "node", "packages/omo-native/bin/senpi-patch.mjs"
    if OS.linux?
      # The optional ARM package contains only musl objects. Build the native Node-API
      # variant from its bundled C++ source; Bun cannot consume a V8-ABI addon.
      node_gyp = formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js"
      with_env("ENABLE_V8_FUNCTIONS" => "false") do
        pattern = "**/node_modules/msgpackr-extract"
        buildpath.glob(pattern, File::FNM_DOTMATCH).map(&:realpath).uniq.each do |package|
          relative = package.relative_path_from(buildpath.realpath)
          odie "Native extractor resolved outside the build tree" if relative.to_s.start_with?("../")
          cd package do
            system formula_opt_bin("node")/"node", node_gyp, "rebuild",
                   "--nodedir=#{formula_opt_prefix("node")}",
                   "--python=#{formula_opt_bin("python@3.15")}/python3.15", "--jobs=#{ENV.make_jobs}"
          end
          odie "Source native extractor was not built" unless (package/"build/Release/extract.node").file?
        end
      end
      # Keep GNU selectors/metadata, source PTY/grep, OpenTUI audio/Yoga and native MessagePack.
      %W[
        @oxc-parser/binding-linux-#{arch}-musl
        @oxfmt/binding-linux-#{arch}-musl
        @oxlint/binding-linux-#{arch}-musl
        @rolldown/binding-linux-#{arch}-musl
        lightningcss-linux-#{arch}-musl
      ].each do |package|
        buildpath.glob("**/node_modules/#{package}", File::FNM_DOTMATCH).each { |path| rm_r path }
      end
      pattern = "**/node_modules/@msgpackr-extract/msgpackr-extract-linux-#{arch}/node.*.musl.node"
      # Bun exposes the same optional object through multiple package-directory aliases.
      buildpath.glob(pattern, File::FNM_DOTMATCH).map(&:realpath).uniq.each do |path|
        relative = path.relative_path_from(buildpath.realpath)
        odie "Native optional binary resolved outside the build tree" if relative.to_s.start_with?("../")
        rm path
      end
    end
    # The SDK selects only its host Linux helper; Darwin uses /usr/bin/sandbox-exec instead.
    pattern = "**/node_modules/@anthropic-ai/sandbox-runtime"
    seccomp_arches = %w[arm64 x64]
    buildpath.glob(pattern, File::FNM_DOTMATCH).map(&:realpath).uniq.each do |package|
      relative = package.relative_path_from(buildpath.realpath)
      odie "Sandbox SDK resolved outside the build tree" if relative.to_s.start_with?("../")
      vendor = package/"vendor"
      if OS.linux?
        sdk_version = JSON.parse((package/"package.json").read).fetch("version")
        odie "Sandbox helper source version mismatch" if sdk_version != "0.0.73"
        seccomp_arches.each { |cpu| rm_r vendor/"seccomp"/cpu }
        resource("sandbox-helper-sources").stage do
          cp "vendor/build-common.ts", vendor
          cp_r "vendor/seccomp-src", vendor
        end
        cd package do
          inreplace "vendor/seccomp/build.ts" do |s|
            s.gsub! "../build-common.js", "../build-common.ts"
            # Homebrew supplies libseccomp and the C runtime through shared libraries.
            s.gsub! "'-static', ", ""
          end
          # Upstream's Bun builder generates both BPF targets and embeds the host filter.
          system bun, "vendor/seccomp/build.ts"
        end
        odie "Source sandbox helper was not built" unless (vendor/"seccomp"/arch/"apply-seccomp").executable?
      else
        rm_r vendor/"seccomp"
      end
    end
    # Do not ship the root package's optional upstream standalone executables.
    rm_r buildpath.glob("node_modules/oh-my-opencode-*")
    rm_r buildpath.glob("node_modules/.bun/oh-my-opencode-*@*")
    buildpath.glob("**/node_modules/koffi/build/koffi/[!.]*", File::FNM_DOTMATCH).each do |dir|
      rm_r dir if dir.basename.to_s != "#{platform}_#{arch}"
    end
    buildpath.glob("**/node_modules/**/prebuilds/[!.]*", File::FNM_DOTMATCH).each do |dir|
      rm_r dir unless [host, "#{host}-gnu"].include?(dir.basename.to_s)
    end
    if OS.mac?
      # Preserve host NAPI library APIs while allowing ordinary Mach-O install-name relocation.
      bindings = [
        ["@oxc-parser", "parser", "liboxc_parser_napi.dylib"],
        ["@oxc-resolver", "resolver", "liboxc_resolver_napi.dylib"],
        ["@rolldown", "rolldown-binding", "librolldown_binding.dylib"],
      ]
      bindings.each do |scope, native_basename, dylib_name|
        pattern = "**/node_modules/#{scope}/binding-darwin-#{arch}"
        buildpath.glob(pattern, File::FNM_DOTMATCH).map(&:realpath).uniq.each do |pkg|
          native_file = pkg/"#{native_basename}.darwin-#{arch}.node"
          relative_file = native_file.relative_path_from(buildpath.realpath)
          odie "Native binding resolved outside the isolated build tree" if relative_file.to_s.start_with?("../")
          binding_version = JSON.parse((pkg/"package.json").read).fetch("version")
          destination = libexec/"native/#{scope.delete_prefix("@")}-#{binding_version}/#{native_basename}.node"
          unless destination.exist?
            destination.dirname.mkpath
            cp native_file, destination
            ln_s "#{native_basename}.node", destination.dirname/dylib_name
          end
          rm native_file
          installed_file = libexec/relative_file
          ln_s destination.relative_path_from(installed_file.dirname), native_file
        end
      end
    end

    libexec.install "packages", "node_modules", "senpi", "package.json", "LICENSE.md", "THIRD-PARTY-NOTICES.md"
    (libexec/"HOMEBREW-MODIFICATIONS").write <<~EOS
      Homebrew builds Senpi, its PTY/grep/clipboard addons, and the OMO plugin from pinned sources.
      Frontend submodules are staged from immutable source resources; dependency installation
      happens during fetch, and the registry Senpi engine is replaced by the source-built tree.
      OpenTUI's real native core is rebuilt from pinned Zig source with relocatable linker padding.
      On Linux, MessagePack's Node-API accelerator and the matching sandbox-runtime C/BPF
      helper are rebuilt from source; Darwin's sandbox-exec implementation is unchanged.
    EOS
    (bin/"omo").write <<~SH
      #!/bin/bash
      export OMO_RUNTIME=node OMO_TELEMETRY=0 OMO_SEND_ANONYMOUS_TELEMETRY=0
      export PATH="#{formula_opt_bin("node")}:#{formula_opt_bin("fd")}:#{formula_opt_bin("ripgrep")}:$PATH"
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/packages/omo-native/bin/omo.js" "$@"
    SH
    chmod 0755, bin/"omo"
  end

  def caveats
    <<~EOS
      This installs the standalone Senpi edition (omo), not the OpenCode plugin.
      Optional Claude Code integration requires your own separately installed Claude Code.
      The bundled OMO plugin uses the source-available Sustainable Use License 1.0.
      The upstream daemon always detaches and explicitly does not support foreground services.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omo --version")
    ENV["OMO_AGENT_DIR"] = testpath/"agent"
    shell_output("#{bin}/omo daemon status --json", 3)
    (testpath/"native-pty.mjs").write <<~JS
      import { TerminalSession } from "#{libexec}/senpi/packages/pty/dist/index.js";
      const session = new TerminalSession({
        command: "/bin/sh",
        args: ["-c", "printf homebrew-pty"],
        cwd: process.cwd(),
        timeoutMs: 5000,
      });
      let output = "";
      let timer;
      const received = new Promise((resolve, reject) => {
        timer = setTimeout(() => reject(new Error("native PTY output timeout")), 5000);
        session.onData((chunk) => {
          output += chunk.toString();
          if (output.includes("homebrew-pty")) resolve();
        });
      });
      try {
        session.start();
        if (session.backend !== "native") throw new Error("source-built native PTY was not selected");
        const [result] = await Promise.all([session.waitExit(), received]);
        if (result.exitCode !== 0 || result.timedOut) throw new Error("native PTY child failed");
        console.log(output);
      } finally {
        clearTimeout(timer);
        await session.terminate({ graceMs: 100, forcedGraceMs: 500 });
      }
    JS
    assert_match "homebrew-pty", shell_output("#{formula_opt_bin("node")}/node native-pty.mjs")
    if OS.linux?
      (testpath/"native-msgpack.cjs").write <<~JS
        const { createRequire } = require("node:module");
        const { dirname } = require("node:path");
        // Follow the plugin's actual locked Effect -> MessagePack dependency chain.
        const plugin = Bun.resolveSync("@opencode-ai/plugin", "#{libexec}");
        const effect = Bun.resolveSync("effect", dirname(plugin));
        const msgpackr = Bun.resolveSync("msgpackr", dirname(effect));
        const native = createRequire(msgpackr)("msgpackr-extract");
        const bytes = Uint8Array.from([0xa1, 0x61, 0xa2, 0xc3, 0xa9]);
        const actual = native.extractStrings(0, bytes.length, bytes.buffer);
        if (JSON.stringify(actual) !== JSON.stringify(["a", "é"])) {
          throw new Error("source native MessagePack extraction failed");
        }
        console.log("source native MessagePack", actual);
      JS
      system formula_opt_bin("bun")/"bun", testpath/"native-msgpack.cjs"
    end
  end
end
