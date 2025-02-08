class CargoGeiger < Formula
  desc "Detects usage of unsafe Rust in a Rust crate and its dependencies"
  homepage "https://github.com/rust-secure-code/cargo-geiger"
  url "https://github.com/geiger-rs/cargo-geiger/archive/refs/tags/cargo-geiger@v0.11.7.tar.gz"
  sha256 "6ddc447b0b8a46ee2b303897fbe2d416df794942cd23984c44b0ee69c4675bad"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  patch do
    url "https://raw.githubusercontent.com/chenrui333/homebrew-tap/ceb0ef84f4d34b992c0f20da279467c06c2590c7/patches/cargo-geiger/0.11.7.patch"
    sha256 "5dde9965fc849e263d4be0a7d3ba317dd829ad3b37f3d67e0359613c9f617271"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-geiger")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-geiger --version")

    mkdir "brewtest" do
      (testpath/"brewtest/src/main.rs").write <<~RUST
        fn main() {
            unsafe {
                let _a = 42;
            }
        }
      RUST

      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"
      TOML

      output = shell_output("#{bin}/cargo-geiger --offline")
      assert_match "1 warning emitted", output
    end
  end
end
