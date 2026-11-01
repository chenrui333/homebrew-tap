class Opencodex < Formula
  desc "Local model proxy and CLI for Codex and other coding agents"
  homepage "https://github.com/lidge-jun/opencodex"
  # The compatibility manifest hashes Git-tracked source files.
  url "https://github.com/lidge-jun/opencodex.git",
      tag:      "v2.95.0",
      revision: "9df4f6a56483ffe62526e29c7d9c6eeed3e742f4"
  license "MIT"
  head "https://github.com/lidge-jun/opencodex.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bun"

  on_linux do
    depends_on "llvm" => :build
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v1.3.0.tar.gz"
    sha256 "349be987e7582e6aa26763b2de96c4cbbd0d3cfba2417d9733524589fdbc275f"
  end

  resource "wreq-js" do
    url "https://github.com/sqdshguy/wreq-js/archive/refs/tags/v2.3.1.tar.gz"
    sha256 "3b4daf3e29a986e099c5089bcf9ff338de8daa4b9ec87d4534df9fa52d52d51d"
  end

  # Bun and Cargo acquire the locked GUI and native companion source dependencies.
  allow_network_access! :build

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s if OS.linux?
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    resource("keyring").stage do
      # The library archive omits Cargo.lock; generate one before the locked source build.
      system "cargo", "generate-lockfile" unless Pathname("Cargo.lock").exist?
      system "cargo", "build", "--lib", "--release", "--locked"
      native = OS.mac? ? "target/release/libnapi_keyring.dylib" : "target/release/libnapi_keyring.so"
      (libexec/"native").install native => "keyring.node"
    end
    resource("wreq-js").stage do
      system "cargo", "build", "--lib", "--release", "--locked", "--manifest-path", "rust/Cargo.toml"
      native = OS.mac? ? "rust/target/release/libwreq_js.dylib" : "rust/target/release/libwreq_js.so"
      target = buildpath/"node_modules/wreq-js/rust"
      target.glob("*.node").each { |path| rm path }
      target.install native => "wreq-js.node"
    end
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    system "cargo", "install", *std_cargo_args(path: "native/remote-workspace-helper", root: libexec/"helper")
    (buildpath/"native-bin/#{platform}").install libexec/"helper/bin/opencodex-remote-workspace-helper"
    cd "gui" do
      system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
      system "bun", "run", "build"
    end
    system "bun", "run", "prepare:package"
    libexec.install "src", "bin", "assets", "package.json", "node_modules", "native-bin"
    (libexec/"gui").install buildpath/"gui/dist"
    # Use brewed Bun and the source-built keyring rather than npm's native payloads.
    rm_r libexec/"node_modules/bun" if (libexec/"node_modules/bun").exist?
    # The wrappers use the declared Homebrew Bun, never npm's scoped runtime payloads.
    rm_r (libexec/"node_modules/@oven").glob("bun-*")
    rm_r (libexec/"node_modules/.bun").glob("@oven+bun-*")
    (libexec/"node_modules/@napi-rs").glob("keyring-*").each { |path| rm_r path }
    %w[ocx opencodex].each do |name|
      (bin/name).write <<~SH
        #!/bin/bash
        export NAPI_RS_NATIVE_LIBRARY_PATH="#{opt_libexec}/native/keyring.node"
        exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/src/cli/index.ts" "$@"
      SH
      chmod 0755, bin/name
    end
  end

  def caveats
    <<~EOS
      This is the standalone ocx/opencodex CLI and local proxy, not the desktop app.
      Native keyring, browser-compatible transport and remote-workspace helper are
      built from source. Provider credentials and upstream agent tools remain user-managed.
      Use ocx start and ocx stop to manage the upstream background proxy.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocx --version")
    assert_match "Invalid port number", shell_output("#{bin}/ocx start --port 0 2>&1", 1)
    assert_match "Only SOCKS5 proxy URLs are supported",
                 shell_output("#{bin}/opencodex start --socks5 socks4://localhost:1080 2>&1", 1)
  end
end
