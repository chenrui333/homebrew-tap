# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.16.tar.gz"
  sha256 "cff5f000e6f07b268ba5f81fab0e564947f1ff54d4bd8928cb2a1639e7377ac0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f547152da19beb4da190caaca7592fa999b016378fb3bb20e7047d459a41ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a5330f6a4dd4cbd7da6b3c8fde5bd10be4de079783550d074bc5ea00817443"
    sha256 cellar: :any_skip_relocation, ventura:       "e2de5f8a18139ee2c3a67e40330df92d1c3466badb07e6c0e432f715ee7bc84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "090b70e1e36d5333ac149feba628d8dd2b08e4e2b367336d145b402ea369ec00"
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
