class Tsuki < Formula
  desc "Lua 5.4 port written in Rust (library for embedding)"
  homepage "https://github.com/ultimaweapon/tsuki"
  url "https://github.com/ultimaweapon/tsuki/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "830838d6a002349c3a094472763a9ee5ac49d238f33d49905ca2653803cebd04"
  license "MIT"
  head "https://github.com/ultimaweapon/tsuki.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5f2e697371ef1f491b0ad9d25f3e5455839443f617197384972ac5abf0be5163"
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
