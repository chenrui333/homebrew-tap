class Openspecui < Formula
  desc "Visual interface for OpenSpec spec-driven development"
  homepage "https://github.com/jixoai/openspecui"
  url "https://github.com/jixoai/openspecui/archive/refs/tags/openspecui%4016.0.0.tar.gz"
  sha256 "418d3e1ec1d562c411a09ef7df3c30b5ec0fbc56d3e2530a1030eb5395611120"
  license "MIT"
  head "https://github.com/jixoai/openspecui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "8c7ac92b03a01c41270d3b6c6d9a2b8e7af75d3259c94cd04baa9f192aabdcc6"
    sha256 cellar: :any, arm64_sequoia: "26515b97306142b89b13c646626304630343677a36f2035a5466c8d336367c57"
    sha256 cellar: :any, arm64_linux:   "5c4a8636dcb83604ca71840eecdd74a35bf06a5f8c38592630fb63ba5c7bdb5f"
    sha256 cellar: :any, x86_64_linux:  "ef441703add4ce82f1ca14437ba0e03b9331cf0a503fb9652b3183ee6d48ba16"
  end

  depends_on "bun" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "node"
  depends_on "openspec"

  resource "opentray" do
    # Source revision from the npm 0.18.0 SLSA provenance attestation.
    url "https://github.com/jixoai/opentray/archive/ed5c6d411b9915563797d894e8203c76a2b345f0.tar.gz"
    sha256 "494c919a6e3a519b467e21254042888a12580eb8ee1dd16fa0627c57994b45ae"
  end

  resource "node-pty" do
    url "https://github.com/lydell/node-pty/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "217d16ccbe7e544dd18ad95e24fb8eba0f9cf1d208a50c0c764b3af222467e2a"
  end

  # Build tools acquire source dependencies; CLI configuration validation stays offline.
  allow_network_access! :build

  def install
    ENV["npm_config_build_from_source"] = "true"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    ENV["PYTHON"] = formula_opt_bin("python@3.14")/"python3.14"
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
    # Both published entrypoints resolve native bindings from their installed production closure.
    inreplace "packages/cli/tsdown.config.ts", "external: [/^node:/],",
              "external: [/^node:/, '@huggingface/transformers', ...CLI_NATIVE_RUNTIME_DEPENDENCIES],"
    system "pnpm", "run", "build:deps"
    system "pnpm", "run", "build:packages"
    system "pnpm", "run", "build:cli"
    # Use upstream's published dist/web/app boundary, not development tools or optional translator binaries.
    system "pnpm", "--filter", "openspecui", "deploy", "--legacy", "--prod", "--ignore-scripts",
           "--config.auto-install-peers=false", "--config.allow-unused-patches=true", buildpath/"runtime"
    libexec.install (buildpath/"runtime").children

    # Compile the installed native closure, so deployment cannot restore producer prebuilds.
    %w[better-sqlite3 @parcel/watcher].each do |name|
      cd (libexec/"node_modules/#{name}").realpath do
        system formula_opt_bin("node")/"node",
               formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js",
               "rebuild", "--verbose"
      end
    end
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    pty_root = libexec.glob("node_modules/.pnpm/@lydell+node-pty-#{platform}@1.1.0*").fetch(0)
    pty_package = pty_root/"node_modules/@lydell/node-pty-#{platform}"
    resource("node-pty").stage do
      package = JSON.parse(Pathname("package.json").read)
      package.delete("devDependencies")
      package["dependencies"] = { "node-addon-api" => "7.1.0" }
      Pathname("package.json").atomic_write(JSON.generate(package))
      system "npm", "install", *std_npm_args(prefix: false), "--package-lock=false"
      system "node", formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js",
             "rebuild"
      pty_package.install "build/Release/pty.node"
      pty_package.install "build/Release/spawn-helper" if OS.mac?
    end
    resource("opentray").stage do
      system "cargo", "install", *std_cargo_args(path: "crates/opentray-bin", root: libexec/"native")
      tray_root = libexec.glob("node_modules/.pnpm/@opentray+#{platform}@0.18.0*").fetch(0)
      tray_package = tray_root/"node_modules/@opentray/#{platform}"
      cp libexec/"native/bin/opentray", tray_package/"bin/opentray"
      if OS.mac?
        system "cargo", "build", "--lib", "--release", "--locked", "--manifest-path",
               "crates/opentray-ext-webview/Cargo.toml"
        ext_root = libexec.glob("node_modules/.pnpm/@opentray+ext-webview-#{platform}@0.18.0*").fetch(0)
        extension = ext_root/"node_modules/@opentray/ext-webview-#{platform}"
        cp "target/release/libopentray_ext_webview.dylib", extension/"lib/libopentray_ext_webview.dylib"
      end
    end
    # Parcel's supported local-build loader must use watcher.node compiled above, not its optional prebuild.
    libexec.glob("node_modules/.pnpm/@parcel+watcher-*").each { |path| rm_r path }
    libexec.find { |path| path.unlink if path.symlink? && !path.exist? }
    (bin/"openspecui").write <<~SH
      #!/bin/bash
      export PATH="#{formula_opt_bin("openspec")}:$PATH"
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dist/cli.mjs" "$@"
    SH
    chmod 0755, bin/"openspecui"
  end

  def caveats
    <<~EOS
      Local translation models and heavyweight translation runtimes are optional
      upstream features and are acquired only when requested in the settings UI.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openspecui --version")
    # macOS's standard Homebrew sandbox denies native recursive filesystem watchers.
    # Reject invalid listen configuration before watchers or a network listener can start.
    shell_output("#{bin}/openspecui --port=-1 2>&1", 1)
  end
end
