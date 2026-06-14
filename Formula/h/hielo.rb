class Hielo < Formula
  desc "Fast and modern tool for working with Iceberg tables"
  homepage "https://github.com/atcol/hielo"
  url "https://github.com/atcol/hielo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fb478daabee44541f93970361fb9f505a84a285655680d6e31228595f1ac9532"
  license "MIT"
  head "https://github.com/atcol/hielo.git", branch: "master"

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
