class CargoComponent < Formula
  desc "Creating WebAssembly components based on the component model proposal"
  homepage "https://github.com/bytecodealliance/cargo-component"
  url "https://github.com/bytecodealliance/cargo-component/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "04ded8443b34687641d0bf01fa682ce46c1a9300af3f13ea5cf1bf5487d6f8b1"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/cargo-component.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eeb52bc5d73b8eb9866b48c99adcb1177d33ee1943c2fb56eb2aa328a109246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdda210dac4428e82f801694fe6100aac7c200501a0763bded158955381f50ba"
    sha256 cellar: :any_skip_relocation, ventura:       "173bbbea08552fbbdcd858ec9b73d5931dc336a4baba56743d7c9c28a755f386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b57190257231c280ef4d4d48f1870ba2b94265450c0e5c9333df49195c760e5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    assert_match version.to_s, shell_output("#{bin}/cargo-component --version")

    system bin/"cargo-component", "new", "test-component", "--lib"
    assert_path_exists testpath/"test-component/Cargo.toml"

    cd testpath/"test-component" do
      system "cargo", "component", "bindings"
      assert_path_exists testpath/"test-component/src/bindings.rs"
    end
  end
end
