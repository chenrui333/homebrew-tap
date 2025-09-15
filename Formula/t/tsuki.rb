class Tsuki < Formula
  desc "Lua 5.4 port written in Rust (library for embedding)"
  homepage "https://github.com/ultimaweapon/tsuki"
  url "https://github.com/ultimaweapon/tsuki/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "ceaba1a8db1694b5244fbacc5ccd8f05a2496c3cbad2384f1f9a3676d8916fc0"
  license "MIT"
  head "https://github.com/ultimaweapon/tsuki.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29fdb17f63afb67c672ea8e6d6ae0ac4c30e3fbac8b352c06d7b0fcba7d65b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a1b3c37dbfc62b8f4ba5f01bf81deee078806e1e2654f0748f52d1e8417b14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "270a1ab8fa0292cfa3f317f581d5b5d77415376be7a464253b7fd28b08f613b5"
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
