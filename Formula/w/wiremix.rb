class Wiremix < Formula
  desc "TUI audio mixer for PipeWire"
  homepage "https://github.com/tsowell/wiremix"
  url "https://github.com/tsowell/wiremix/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "dfb165ff664b804099c5592fd26d2b03d78e67069522bc5d3d8ef75a19505adf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tsowell/wiremix.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "pipewire"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib if OS.linux?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wiremix #{version}", shell_output("#{bin}/wiremix --version")
  end
end
