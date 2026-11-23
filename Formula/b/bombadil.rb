class Bombadil < Formula
  desc "Property-based testing for web and terminal UIs"
  homepage "https://antithesishq.github.io/bombadil/"
  url "https://github.com/antithesishq/bombadil/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "36462c87a4aa55a9026563eb922b74f6d089dbf83d00fd7bc81b855259982728"
  license "MIT"
  head "https://github.com/antithesishq/bombadil.git", branch: "main"

  depends_on "binaryen" => :build
  depends_on "pkgconf" => :build
  depends_on "rustup" => :build
  depends_on "trunk" => :build
  depends_on "zig" => :build

  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty/archive/108cacb17ed8990840cd14abfce43d8ed8503ca1.tar.gz"
    sha256 "2c276d3e62cb15fb38f0d7f621f199029d1d4df86538096c6bec2a107cad7159"
  end

  resource "wasm-bindgen" do
    url "https://static.crates.io/crates/wasm-bindgen-cli/wasm-bindgen-cli-0.2.121.crate"
    sha256 "798e989740602cfbbd28aab1597ef6cacbf50f0e08f739936bf5d0ab13d230b2"
  end

  deny_network_access!

  RUST_TOOLCHAIN = "1.100.0".freeze

  def fetch
    source = Pathname.pwd
    ENV["RUSTUP_HOME"] = source/".rustup"
    system "rustup", "toolchain", "install", RUST_TOOLCHAIN, "--profile", "minimal",
           "--target", "wasm32-unknown-unknown", "--no-self-update"
    system "rustup", "run", RUST_TOOLCHAIN, "cargo", "fetch", "--locked"

    wasm_bindgen = source/".brew-wasm-bindgen"
    resource("wasm-bindgen").stage wasm_bindgen
    # Keep this build tool out of Bombadil's Cargo workspace.
    (wasm_bindgen/"Cargo.toml").append_lines "\n[workspace]"
    cd wasm_bindgen do
      system "rustup", "run", RUST_TOOLCHAIN, "cargo", "fetch", "--locked"
    end

    resource("ghostty").stage source/"ghostty"
    ENV["ZIG_GLOBAL_CACHE_DIR"] = source/"zig-cache"
    cd "ghostty" do
      system "zig", "build", "--fetch=all", "-Demit-lib-vt=true", "-Dapp-runtime=none",
             "-Demit-xcframework=false"
    end
  end

  def install
    source = Pathname.pwd
    ENV["RUSTUP_HOME"] = source/".rustup"
    ENV["RUSTUP_TOOLCHAIN"] = RUST_TOOLCHAIN
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    cargo = formula_opt_bin("rustup")/"cargo"
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["GHOSTTY_SOURCE_DIR"] = source/"ghostty"
    ENV["ZIG_GLOBAL_CACHE_DIR"] = source/"zig-cache"

    tools = source/"build-tools"
    wasm_bindgen = source/".brew-wasm-bindgen"
    cd wasm_bindgen do
      system cargo, "install", "--locked", "--offline", "--root", tools, "--path", "."
    end
    ENV.prepend_path "PATH", tools/"bin"

    system cargo, "install", *std_cargo_args(path: "lib/bombadil-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bombadil --version")
    output = shell_output("#{bin}/bombadil trace #{testpath}/missing.trace 2>&1", 1)
    assert_match "missing.trace", output
  end
end
