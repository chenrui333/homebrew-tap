class Tsuki < Formula
  desc "Lua 5.4 port written in Rust (library for embedding)"
  homepage "https://github.com/ultimaweapon/tsuki"
  url "https://github.com/ultimaweapon/tsuki/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "54b4a911bcd6eaad9a9b7d064cddb3089a6a01c8a324ddf7b65ddacdef1aaf93"
  license "MIT"
  head "https://github.com/ultimaweapon/tsuki.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1ab30ce39aef31b06ce3a73610ce616c5f3e0f33e8cf444c57c4ca8ce67ebaa9"
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
