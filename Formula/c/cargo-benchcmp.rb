class CargoBenchcmp < Formula
  desc "Cargo subcommand to compare Rust micro-benchmarks"
  homepage "https://github.com/BurntSushi/cargo-benchcmp"
  url "https://github.com/BurntSushi/cargo-benchcmp/archive/refs/tags/0.4.5.tar.gz"
  sha256 "3dc68e5c99b344d74e6a7c838445812037f658f1252f374af5ced644ec5f853c"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/cargo-benchcmp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b323725e068391d617856ec577aa0af2410a5aeaec03c81c0de302bedc27f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0504a133059a792f5cdc78ad24c9f0a5125965cf864e786ae7e76719191ac219"
    sha256 cellar: :any_skip_relocation, ventura:       "082fbb8d221b891a59bde8e69dda5b0bc067b205081c83db3ed250988c30011b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58123256bda923c78f21bcbcb65afa384a20065a09a4a3daf2959b46c155c80"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("cargo benchcmp --version")
  end
end
