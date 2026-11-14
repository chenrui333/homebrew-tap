class OhMyOpenagent < Formula
  desc "Multi-model agent orchestration plugin and toolkit for OpenCode and Codex"
  homepage "https://github.com/code-yeongyu/oh-my-openagent"
  url "https://github.com/code-yeongyu/oh-my-openagent/archive/refs/tags/v5.1.70.tar.gz"
  sha256 "f0217346c919f2a61411ff476a490d94a60ed4accb241213c405051ccff20a42"
  # Sustainable Use License 1.0 permits only free, non-commercial redistribution.
  license :cannot_represent
  head "https://github.com/code-yeongyu/oh-my-openagent.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "d4cb1cff8b9a291c45fa52ca2760c2a6b06f7429e3e48ef0abba0e3d4fb47041"
    sha256 cellar: :any, arm64_sequoia: "8622f57483dba563f42889eb0b3235a8a83bd6dbcab173354370f4e59f4e13b7"
    sha256 cellar: :any, arm64_linux:   "50424aa46df22b12c94925890ded40d3d7bbb4a95f6c1e942f49a1e6b3f5c366"
    sha256 cellar: :any, x86_64_linux:  "7da487cb9f2d2c22a464bc173fefbbdc6187fe5a01d96b2e1dc151f0bc737600"
  end

  depends_on "esbuild" => :build
  depends_on "rust" => :build
  depends_on "zig@0.16" => :build
  depends_on "bun"
  depends_on "node"

  on_linux do
    depends_on "python@3.15" => :build
    depends_on "libxcb"
  end

  resource "comment-checker-source" do
    url "https://github.com/code-yeongyu/go-claude-code-comment-checker/archive/ec3c30c1f4c51a245ab82ffca74241868f902f3f.tar.gz"
    sha256 "d82f2d74a41d1227a1658f163f97ba485f730d1e6ec3288d4af1a3244d341c8e"
  end

  resource "comment-checker-parsers" do
    url "https://github.com/kreuzberg-dev/tree-sitter-language-pack/releases/download/v1.8.1/parser-sources-1.8.1.tar.zst"
    sha256 "29c76cf27f17edd1398118553ddde9be8b9e9970c0017b387c53466cf2e48717"
  end

  resource "comment-checker-parsers-checksum" do
    url "https://github.com/kreuzberg-dev/tree-sitter-language-pack/releases/download/v1.8.1/parser-sources-1.8.1.tar.zst.sha256"
    sha256 "f5ae921c9735655f4508861c666a075e5ac9c58b08e91783a5454c7294fa3cd5"
  end

  resource "opentui-native" do
    url "https://github.com/anomalyco/opentui/archive/6b9863ea7c5fae22bfebb23c242ddcc4c2b0aa0e.tar.gz"
    sha256 "6f3854e067fd34abc31c1d3360a00ff65ca13df734b34dc09b23137dec5c4e86"
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
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--ignore-scripts"
    %w[lsp-tools-mcp lsp-daemon omo-codex/plugin].each do |component|
      cd "packages/#{component}" do
        system "npm", "ci", "--ignore-scripts", "--no-audit", "--no-fund"
      end
    end
    resource("comment-checker-source").stage(buildpath/"comment-checker-source")
    cd "comment-checker-source" do
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
    # Use Homebrew's build tool instead of allowing bun x to download esbuild during compilation.
    inreplace "packages/omo-codex/plugin/components/bootstrap/scripts/build.mjs" do |s|
      s.gsub! "\"bun\",", "\"#{formula_opt_bin("esbuild")}/esbuild\","
      s.gsub! '["x", "esbuild", ', "["
    end
    resources.reject { |r| r.name.start_with?("comment-checker-") || r.name == "opentui-native" }.each do |r|
      r.stage buildpath/"packages/shared-skills/upstreams/#{r.name}"
    end
    # Homebrew stages the exact gitlink resources above, without a mutable submodule checkout.
    inreplace "packages/omo-codex/plugin/scripts/materialize-shared-upstreams.mjs",
              "await initSubmodules({ strict });", "// Pinned submodules staged by Homebrew."
    %w[lsp-tools-mcp lsp-daemon omo-codex/plugin].each do |component|
      inreplace "package.json", "npm --prefix packages/#{component} ci && ", ""
    end
    # The optional platform packages are upstream standalone executables, not runtime libraries.
    rm_r buildpath.glob("node_modules/oh-my-opencode-*")
    rm_r buildpath.glob("node_modules/.bun/oh-my-opencode-*@*")
    # Proprietary Claude Code remains an optional, separately installed integration.
    rm_r buildpath.glob("**/node_modules/@anthropic-ai/claude-agent-sdk-{darwin,linux,win32}-*")
    rm_r buildpath.glob("**/node_modules/.bun/@anthropic-ai+claude-agent-sdk-{darwin,linux,win32}-*@*")
    system bun, "run", "build"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    # Compile OpenTUI's real native core with Mach-O padding for Homebrew's install-name relocation.
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

      if pkg.basename.to_s == "core-#{platform}-#{arch}"
        rm pkg/native_name
        ln_s libexec/"opentui"/native_name, pkg/native_name
      else
        rm_r pkg
      end
    end
    # Replace every npm helper copy with the exact locked version compiled from public source.
    # Keep every upstream-selected grammar statically compiled; supply the verified source bundle offline.
    parser_bundle = buildpath/"parser-sources-1.8.1.tar.zst"
    cp resource("comment-checker-parsers").cached_download, parser_bundle
    cp resource("comment-checker-parsers-checksum").cached_download, "#{parser_bundle}.sha256"
    ENV["TSLP_SOURCE_BUNDLE_URL"] = "file://#{parser_bundle}"
    cd "comment-checker-source" do
      system "cargo", "install", *std_cargo_args(root: libexec/"comment-checker")
    end
    buildpath.glob("**/node_modules/@code-yeongyu/comment-checker", File::FNM_DOTMATCH).each do |pkg|
      rm_r pkg/"vendor" if (pkg/"vendor").exist?
      rm_r pkg/"bin" if (pkg/"bin").exist?
      (pkg/"bin").mkpath
      ln_s libexec/"comment-checker/bin/comment-checker", pkg/"bin/comment-checker"
    end
    buildpath.glob("**/node_modules/koffi/build/koffi/[!.]*", File::FNM_DOTMATCH).each do |dir|
      rm_r dir if dir.basename.to_s != "#{platform}_#{arch}"
    end
    buildpath.glob("**/node_modules/**/prebuilds/[!.]*", File::FNM_DOTMATCH).each do |dir|
      rm_r dir unless ["#{platform}-#{arch}", "#{platform}-#{arch}-gnu"].include?(dir.basename.to_s)
    end
    if OS.linux?
      # Rebuild the locked Senpi X11 addon against Homebrew's libxcb, not its producer's system library.
      pattern = "**/node_modules/@code-yeongyu/senpi-tui"
      buildpath.glob(pattern, File::FNM_DOTMATCH).map(&:realpath).uniq.each do |package|
        relative = package.relative_path_from(buildpath.realpath)
        odie "Native clipboard resolved outside the build tree" if relative.to_s.start_with?("../")
        cd package do
          rm_r "native/linux/prebuilds"
          system "bash", "native/linux/build.sh"
        end
      end
      # The locked ARM optional package has only musl objects. Compile the same
      # native extraction API through its upstream Node-API variant for Bun.
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
      # Ordinary glibc selectors and same-version GNU bindings remain unchanged.
      %W[
        @oxc-parser/binding-linux-#{arch}-musl
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
    if OS.mac?
      # Keep standard host NAPI libraries in short versioned paths so vendor Mach-O IDs can relocate.
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

      # Senpi's host addon has the same Mach-O ID constraint, but a different package layout.
      pattern = "**/node_modules/@code-yeongyu/senpi-pty"
      buildpath.glob(pattern, File::FNM_DOTMATCH).map(&:realpath).uniq.each do |pkg|
        native_file = pkg/"native/prebuilds/darwin-#{arch}/senpi_pty.darwin-#{arch}.node"
        relative_file = native_file.relative_path_from(buildpath.realpath)
        odie "Native PTY resolved outside the isolated build tree" if relative_file.to_s.start_with?("../")
        binding_version = JSON.parse((pkg/"package.json").read).fetch("version")
        destination = libexec/"native/senpi-pty-#{binding_version}/senpi_pty.node"
        unless destination.exist?
          destination.dirname.mkpath
          cp native_file, destination
          ln_s "senpi_pty.node", destination.dirname/"libsenpi_pty.dylib"
        end
        rm native_file
        installed_file = libexec/relative_file
        ln_s destination.relative_path_from(installed_file.dirname), native_file
      end
    end

    # Keep every plugin edition, bundled MCP server, schema, skill, and runtime asset.
    libexec.install "dist", "bin", "packages", "node_modules", "package.json", "script", "docs",
                    ".agents", ".opencode", "LICENSE.md", "THIRD-PARTY-NOTICES.md"
    (libexec/"HOMEBREW-MODIFICATIONS").write <<~EOS
      Homebrew stages pinned frontend-skill source resources instead of git submodule update
      and installs dependency closures during fetch instead of running npm ci during build.
      OpenTUI and comment-checker are compiled from pinned public native source.
      On Linux, the locked MessagePack accelerator is compiled from its bundled C++ source
      using the upstream Node-API interface, without disabling native acceleration.
      The locked Senpi X11 clipboard addon is also rebuilt from its delivered C/NAPI source.
      The bootstrap uses Homebrew's esbuild instead of downloading a compiler during build.
    EOS
    %w[oh-my-openagent oh-my-opencode omo-agent-toolkit lazycodex lazycodex-ai].each do |command|
      (bin/command).write <<~SH
        #!/bin/bash
        export OMO_INVOCATION_NAME="#{command}"
        exec "#{bun}" "#{libexec}/dist/cli/index.js" "$@"
      SH
      chmod 0755, bin/command
    end
  end

  def caveats
    <<~EOS
      This is the OpenCode/Codex plugin and toolkit, not the standalone Senpi edition (omo-ai).
      Plugin entrypoint: #{opt_libexec}/dist/index.js
      This source-available package uses the Sustainable Use License 1.0.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-openagent --version")
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    legacy = testpath/".config/opencode/oh-my-openagent.json"
    legacy.dirname.mkpath
    original = JSON.generate(disabled_providers: ["homebrew-fixture-provider"], model_fallback: false)
    legacy.write original
    system bin/"oh-my-openagent", "config", "migrate", "--dry-run", "--json"
    assert_equal original, legacy.read
    refute_path_exists testpath/".omo/omo.jsonc"
    system bin/"oh-my-openagent", "config", "migrate"
    # The tagged migration intentionally drops legacy agents/categories but preserves these user settings.
    migrated = (testpath/".omo/omo.jsonc").read
    assert_match "homebrew-fixture-provider", migrated
    assert_match '"model_fallback": false', migrated
    script = "await import('#{libexec}/dist/index.js'); console.log('plugin loaded')"
    output = shell_output("#{formula_opt_bin("bun")}/bun -e #{script.shellescape}")
    assert_match "plugin loaded", output
    (testpath/"hook.json").write JSON.generate(
      tool_name: "Write", tool_input: { file_path: "brew.py", content: "# comment\nprint(1)" },
    )
    checker = libexec/"packages/omo-codex/plugin/node_modules/@code-yeongyu/comment-checker/cli.js"
    output = shell_output("#{formula_opt_bin("node")}/node #{checker} < #{testpath}/hook.json 2>&1", 2)
    assert_match "COMMENT/DOCSTRING DETECTED", output
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
