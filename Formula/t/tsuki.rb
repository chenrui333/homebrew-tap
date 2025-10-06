class Tsuki < Formula
  desc "Lua 5.4 port written in Rust (library for embedding)"
  homepage "https://github.com/ultimaweapon/tsuki"
  url "https://github.com/ultimaweapon/tsuki/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "242e59f7a81fe7eb9c89da659a90119d849b060adb5ff9487e897df9c23ee5af"
  license "MIT"
  head "https://github.com/ultimaweapon/tsuki.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46770c1363af0d33594f701f60e2e25b6e883118a4de3010ce6e9261e337b08e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a3a4b5dde84864f2a1ce1dcadf4261e54540be91a30c2cafa24f2302d09889a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99a5791cce677329455f42e30c5a2ceb4e3149ebd2144363a219880b7a99660f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23ab9c4924d05afe232e1bdc456eef1a1b2df8275c7dc39f1b600e3a8531f6f"
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
