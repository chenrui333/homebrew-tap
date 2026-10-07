class Wiremix < Formula
  desc "TUI audio mixer for PipeWire"
  homepage "https://github.com/tsowell/wiremix"
  url "https://github.com/tsowell/wiremix/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "62a7cace79c9af537e0917a6d4e5da66b2efe2b4abc5f08c0fbaed727acc8c9f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tsowell/wiremix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "2a5ef7aa734ca010f38fab1ebabcedfc3d9940b870f0995a5c5f5b2331120788"
    sha256 cellar: :any, x86_64_linux: "ff751d83a19c4a5dca2bf80d5d1c8e06e93b1d64aaee06dfe6c87220069bc494"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "pipewire"

  on_linux do
    depends_on "llvm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wiremix v#{version}", shell_output("#{bin}/wiremix --version")
  end
end
