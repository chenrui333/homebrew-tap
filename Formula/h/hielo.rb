class Hielo < Formula
  desc "Fast and modern tool for working with Iceberg tables"
  homepage "https://github.com/atcol/hielo"
  url "https://github.com/atcol/hielo/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "60f4151ce485fba05c95c806d0190edc9317fc279e34073c4d836ce331db096d"
  license "MIT"
  head "https://github.com/atcol/hielo.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "patchelf" => :build
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsoup"
    depends_on "webkitgtk"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"hielo", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "could not create directory", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
