class Tsuki < Formula
  desc "Lua 5.4 port written in Rust (library for embedding)"
  homepage "https://github.com/ultimaweapon/tsuki"
  url "https://github.com/ultimaweapon/tsuki/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "8649dca0c9398dcfa4d11685115fc32dd5052e4aac00073513bba65a0396946e"
  license "MIT"
  head "https://github.com/ultimaweapon/tsuki.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e55fbdcb10bfc04533fb844d3a3fee4b33be1216692f830f67ac288cd948d871"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release"
    rm_r("target")
    pkgshare.install Dir["*"]
  end

  test do
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

    assert_equal "ok", shell_output("cargo run --quiet").strip
  end
end
