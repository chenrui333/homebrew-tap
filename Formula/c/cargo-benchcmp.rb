class CargoBenchcmp < Formula
  desc "Cargo subcommand to compare Rust micro-benchmarks"
  homepage "https://github.com/BurntSushi/cargo-benchcmp"
  url "https://github.com/BurntSushi/cargo-benchcmp/archive/refs/tags/0.4.5.tar.gz"
  sha256 "3dc68e5c99b344d74e6a7c838445812037f658f1252f374af5ced644ec5f853c"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/cargo-benchcmp.git", branch: "master"

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("cargo benchcmp --version")
  end
end
