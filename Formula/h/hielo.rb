class Hielo < Formula
  desc "Fast and modern tool for working with Iceberg tables"
  homepage "https://github.com/atcol/hielo"
  url "https://github.com/atcol/hielo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fb478daabee44541f93970361fb9f505a84a285655680d6e31228595f1ac9532"
  license "MIT"
  head "https://github.com/atcol/hielo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2bd7cf5f86757e5981933661e74e00e523bdd2e8c788162a718e2b2e30f2ca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "300c65ce6803562f317a3da209325bc5cf077fae87211f7fa51ed5f2616fbf8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a01f43de752ff2086e2d78d2a01afca35954bb9ca832866fceca7bb8c1239b88"
    sha256 cellar: :any,                 arm64_linux:   "7181fd35ffa3f45cbbbc5879b351a383e7d41c088eca2afeef2f073729a64a6f"
    sha256 cellar: :any,                 x86_64_linux:  "585405c0f1ff4f6ce4781586282306b4e76a25a63863efdf27bfd7ddc2fa0be6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "patchelf" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsoup"
    depends_on "webkitgtk"
    depends_on "xdotool"
  end

  def install
    inreplace "src/main.rs", <<~RUST, <<~RUST
      fn main() {
          dioxus_logger::init(tracing::Level::INFO).expect("failed to init logger");
    RUST
      fn main() {
          if std::env::args().any(|arg| arg == "--version" || arg == "-V") {
              println!("hielo {}", env!("CARGO_PKG_VERSION"));
              return;
          }

          dioxus_logger::init(tracing::Level::INFO).expect("failed to init logger");
    RUST

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hielo --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"hielo", testpath, [:out, :err] => output_log.to_s
    sleep 1
    if OS.mac?
      assert Process.kill(0, pid)
    else
      assert_match(/cannot open display|could not create directory/, output_log.read)
    end
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
