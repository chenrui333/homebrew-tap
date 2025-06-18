class CargoComponent < Formula
  desc "Creating WebAssembly components based on the component model proposal"
  homepage "https://github.com/bytecodealliance/cargo-component"
  url "https://github.com/bytecodealliance/cargo-component/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "0b3d299c4cb26956b0f0bb673d09cbb4c0a826efbd2dc4805e68db91552c041d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/cargo-component.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58b1df80d69c48d0a5a946bbf69ef3a4f1445356a934864d001fe1f593c51121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c2439d2781a32a450a071ca922f31396269ea04c2bd6f37ab6f69913b10c481"
    sha256 cellar: :any_skip_relocation, ventura:       "bb881bf4315adef3c22eeda5d0612f8ad5a803cda80942f3adabc19780406ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f42a047c330a2fc5b48af299163cc302b4293ed111d7d6b3ca7fc7470ddf3ef7"
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
