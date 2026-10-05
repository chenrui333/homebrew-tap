class Hielo < Formula
  desc "Fast and modern tool for working with Iceberg tables"
  homepage "https://github.com/atcol/hielo"
  url "https://github.com/atcol/hielo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fb478daabee44541f93970361fb9f505a84a285655680d6e31228595f1ac9532"
  license "MIT"
  head "https://github.com/atcol/hielo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e223732603f4ff9f4259b9823d80638daddc4ec95061be8c564a2bfc7d02e72b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e1950f7d5cab9c7fd41771213e7d9be366f01328798b960bf20c86df5fd8b1d"
    sha256 cellar: :any,                 arm64_linux:   "684ab4f6bb4572d25487c261f06aba5fcdfcd1e8df508a3c726a1c380703977a"
    sha256 cellar: :any,                 x86_64_linux:  "1d619b87c6d91b1c0648602d939aaffedf12f478615382cff032528a2b0bd41f"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
