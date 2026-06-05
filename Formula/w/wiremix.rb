class Wiremix < Formula
  desc "TUI audio mixer for PipeWire"
  homepage "https://github.com/tsowell/wiremix"
  url "https://github.com/tsowell/wiremix/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "62a7cace79c9af537e0917a6d4e5da66b2efe2b4abc5f08c0fbaed727acc8c9f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tsowell/wiremix.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "a692ef57ef832b970273a9542e1301126d7a37e4bd28a9519115c57b4b85e674"
    sha256 cellar: :any, x86_64_linux: "9e5ad32825004578de25ee5afd3ecb644784cbe91f579b5e2f493d418944ae76"
  end

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
    assert_match "wiremix v#{version}", shell_output("#{bin}/wiremix --version")
  end
end
