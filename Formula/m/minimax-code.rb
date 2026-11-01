class MinimaxCode < Formula
  desc "Terminal coding agent with MiniMax and bring-your-own-key models"
  homepage "https://github.com/MiniMax-AI/minimax-code"
  url "https://github.com/MiniMax-AI/minimax-code/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "abea95f30499016b5e60d499fae15a8a56e203f2453b0d49ac960b0fb9346ea8"
  license "MIT"
  head "https://github.com/MiniMax-AI/minimax-code.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "1bfe624b04bd7c76fa4a2ab9b5524af4a745735da47e39b3e7ae6fcc50894ea4"
    sha256 cellar: :any, arm64_sequoia: "749070b0d4a43007a779870219abde322b0c87bebd653cd841d1f3c6a5263e80"
    sha256 cellar: :any, arm64_linux:   "f7724773f10afa0d29c9cac319c47d30380f58f515cc720c9978a32795fd5e96"
    sha256 cellar: :any, x86_64_linux:  "b946e4f653986517a6c166411787fcd6f0f565533fde9cf0a8a2d25006be13be"
  end

  depends_on "bun" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "python@3.14" => :build
  depends_on "node"
  depends_on "ripgrep"

  on_linux do
    depends_on "libseccomp"
  end

  # Upstream's separately versioned mcode-tools JS dependency has no original source in this repo.
  # The primary CLI is built below; retain this integrity-checked dependency and its notices.
  resource "mcode-tools-javascript" do
    url "https://registry.npmjs.org/@minimax-ai/code/-/code-0.3.11.tgz"
    sha256 "d2e160be6081dd69b48da661bc6f9a6e049d258cbd0b3121ef1185d7ece52662"
  end

  deny_network_access!

  def fetch
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts",
           "--config.manage-package-manager-versions=false", "--config.package-manager-strict=false"
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    ENV["npm_config_build_from_source"] = "true"
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")/"libexec/openjdk.jdk/Contents/Home" if OS.mac?
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")/"libexec" if OS.linux?
    # Compile the two required native addons explicitly, without download/install-script fallbacks.
    node_gyp = formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js"
    %w[better-sqlite3 node-pty].each do |addon|
      cd "node_modules/#{addon}" do
        inreplace "binding.gyp", "c++17", "c++20" if File.read("binding.gyp").include?("c++17")
        system formula_opt_bin("node")/"node", node_gyp, "rebuild", "--release",
               "--nodedir=#{formula_opt_prefix("node")}", "--jobs=#{ENV.make_jobs}"
      end
    end

    # Replace the release's executable dependencies with source-built Homebrew tools.
    rg = buildpath/"node_modules/@vscode/ripgrep/bin/rg"
    rg.dirname.mkpath
    rm rg if rg.exist?
    ln_s formula_opt_bin("ripgrep")/"rg", rg
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    host = "#{platform}-#{arch}"
    rm_r buildpath.glob("packages/tui/native/*/prebuilds/*")
    rm_r buildpath.glob("third_party/pi-mono/packages/tui/native/*/prebuilds/*")
    rm_r buildpath/"node_modules/node-pty/prebuilds"
    if OS.mac?
      native = buildpath/"packages/tui/native/darwin/prebuilds/#{host}"
      native.mkpath
      system ENV.cc, "-O2", "-bundle", "-undefined", "dynamic_lookup", "-framework", "CoreGraphics",
             "third_party/pi-mono/packages/tui/native/darwin/src/darwin-modifiers.c",
             "-o", native/"darwin-modifiers.node"
    end
    # Windows helpers are not part of the macOS/Linux runtime closure.
    rm_r buildpath.glob("third_party/sandbox-runtime/vendor/srt-win/{arm64,x64}")
    rm_r buildpath.glob("third_party/sandbox-runtime/vendor/seccomp/{arm64,x64}")
    if OS.linux?
      # Homebrew supplies libseccomp and libc dynamically, not static glibc archives.
      inreplace "third_party/sandbox-runtime/vendor/seccomp/build.ts", "'-static', ", ""
      system bun, "third_party/sandbox-runtime/vendor/seccomp/build.ts"
    end
    system bun, "third_party/sandbox-runtime/vendor/java-proxy-agent/build.ts"
    (buildpath/".cache/artifacts").mkpath
    cp resource("mcode-tools-javascript").cached_download, buildpath/".cache/artifacts/code-0.3.11.tgz"
    system "node", "scripts/build.mjs"

    # External imports in dist must resolve to the exact installed workspace dependency closure.
    %w[better-sqlite3 @mariozechner/clipboard @vscode/ripgrep @larksuiteoapi/node-sdk].each do |name|
      # Upstream's .npmrc explicitly uses pnpm's hoisted node linker.
      dependency = buildpath/"node_modules"/name
      odie "Missing runtime dependency: #{name}" unless dependency.directory?
      target = buildpath/"dist/node_modules/#{name}"
      target.dirname.mkpath
      ln_s dependency.relative_path_from(target.dirname), target
    end
    buildpath.glob("node_modules/**/prebuilds/[!.]*", File::FNM_DOTMATCH).each do |dir|
      rm_r dir unless [host, "#{host}-gnu"].include?(dir.basename.to_s)
    end
    if OS.linux?
      # These loaders select the retained -gnu packages on Homebrew's glibc hosts.
      # Their separately packaged musl variants are not under prebuilds/ and require libc.so.
      %w[@oxc-parser/binding @oxc-resolver/binding @rollup/rollup].each do |addon|
        rm_r buildpath/"node_modules/#{addon}-#{host}-musl"
      end
    end
    libexec.install "dist", "node_modules", "packages", "third_party", "package.json",
                    "LICENSE", "NOTICE", "THIRD_PARTY_NOTICES.md"
    %w[mcode mcode-tools].each do |command|
      entrypoint = (command == "mcode") ? "cli.js" : "mcode-tools.js"
      (bin/command).write <<~SH
        #!/bin/bash
        exec "#{formula_opt_bin("node")}/node" "#{libexec}/dist/#{entrypoint}" "$@"
      SH
      chmod 0755, bin/command
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcode --version")
    ENV.delete "HOMEBREW_MCODE_MISSING_KEY"
    output = shell_output("#{bin}/mcode provider add --name Homebrew --base-url http://127.0.0.1:1 " \
                          "--model brew --api-key-env HOMEBREW_MCODE_MISSING_KEY 2>&1", 1)
    assert_match "Provider API key is missing. Set HOMEBREW_MCODE_MISSING_KEY", output
    assert_path_exists bin/"mcode-tools"
  end
end
