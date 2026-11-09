class CargoBenchcmp < Formula
  desc "Cargo subcommand to compare Rust micro-benchmarks"
  homepage "https://github.com/BurntSushi/cargo-benchcmp"
  url "https://github.com/BurntSushi/cargo-benchcmp/archive/refs/tags/0.4.5.tar.gz"
  sha256 "3dc68e5c99b344d74e6a7c838445812037f658f1252f374af5ced644ec5f853c"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/cargo-benchcmp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b72a17e12cbaac870fc0c5ffc953e272b1ec4f784c08f8804ef821279234d49f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d005a0c3249e7bcc5dd3d4ab5b3e8937eef147bfa8033cc90ccb3c54431e2a8"
    sha256 cellar: :any,                 arm64_linux:   "a6156c41b51dc9d52b27d90d80d5894161160ac1beee34cce03e281ca1abd895"
    sha256 cellar: :any,                 x86_64_linux:  "22e334fa08aba35a3bdd61d95f023da2a4832e69eb1d9c7088d8cb4ae7b52f0f"
  end

  depends_on "rust" => [:build, :test]

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("cargo benchcmp --version")

    (testpath/"old.txt").write <<~EOS
      test bench_a ... bench: 1,000 ns/iter (+/- 10)
      test bench_b ... bench: 2,000 ns/iter (+/- 20)
    EOS
    (testpath/"new.txt").write <<~EOS
      test bench_b ... bench: 4,000 ns/iter (+/- 40)
      test bench_a ... bench: 500 ns/iter (+/- 5)
    EOS

    output = shell_output("cargo benchcmp --color never old.txt new.txt")
    comparisons = output.lines.grep(/^\s*bench_/).map { |line| line.split.values_at(0, 1, 2, 3, 4, 6) }
    assert_equal [
      ["bench_a", "1,000", "500", "-500", "-50.00%", "2.00"],
      ["bench_b", "2,000", "4,000", "2,000", "100.00%", "0.50"],
    ], comparisons
  end
end
