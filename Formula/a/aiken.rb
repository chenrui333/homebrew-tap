# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.16.tar.gz"
  sha256 "cff5f000e6f07b268ba5f81fab0e564947f1ff54d4bd8928cb2a1639e7377ac0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd6c9e37b067ef48443cf075983e46b33677057d18208b3ec3f119741b409f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd9f4bd4d3c00d83ca793d10147eab13e88f4049f1396f8520ebcc9b3bd01f4"
    sha256 cellar: :any_skip_relocation, ventura:       "88d6d55df42d4d84b715b2412c9e9a7d3c211279a9d988b720ec824e49340929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a15a1d7af9b2c8c54fa9fc34331903a0115e9fa1082d8157260155336bad11f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end
