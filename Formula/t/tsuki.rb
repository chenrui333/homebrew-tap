class Tsuki < Formula
  desc "Lua 5.4 port written in Rust (library for embedding)"
  homepage "https://github.com/ultimaweapon/tsuki"
  url "https://github.com/ultimaweapon/tsuki/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "f6bc05782084880e8285da34534fb1def327c5720e364185a760a678dd9a2ebc"
  license "MIT"
  head "https://github.com/ultimaweapon/tsuki.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "18b86c22fe24b07fe074fdf0d24711f2180f8a6c13fd6ebbe0a0d3c96e8c7612"
  end

  depends_on "rust" => [:build, :test]

  deny_network_access!

  def fetch
    # Upstream does not commit Cargo.lock; resolve once during fetch so the build stays offline.
    system "cargo", "generate-lockfile"
    # Fetch for all targets so `cargo vendor --offline` in install has every platform's crates.
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release", "--offline"
    rm_r("target")

    # Vendor tsuki's runtime (non-dev) dependencies so crates built against it work offline.
    vendor_probe = buildpath/"brew-vendor-probe"
    (vendor_probe/"src").mkpath
    (vendor_probe/"src/main.rs").write "fn main() {}\n"
    (vendor_probe/"Cargo.toml").write <<~TOML
      [package]
      name = "brew-vendor-probe"
      version = "0.0.0"
      edition = "2021"

      [dependencies]
      tsuki = { path = "#{buildpath}" }

      [workspace]
    TOML
    cp "Cargo.lock", vendor_probe
    cd vendor_probe do
      system "cargo", "vendor", "--offline", buildpath/"vendor"
    end
    rm_r vendor_probe

    pkgshare.install Dir["*"]
  end

  test do
    (testpath/".cargo/config.toml").write <<~TOML
      [source.crates-io]
      replace-with = "vendored-sources"

      [source.vendored-sources]
      directory = "#{pkgshare}/vendor"
    TOML

    (testpath/"Cargo.toml").write <<~EOS
      [package]
      name = "tsuki_probe"
      version = "0.1.0"
      edition = "2021"

      [dependencies]
      tsuki = { path = "#{pkgshare}" }
    EOS

    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~EOS
      fn main() {
        // Pass unit `()` as associated data; just proving API/linkage works.
        let _lua = tsuki::Lua::new(());
        println!("ok");
      }
    EOS

    assert_equal "ok", shell_output("cargo run --offline --quiet").strip
  end
end
