# framework: clap
class Alejandra < Formula
  desc "Uncompromising Nix Code Formatter"
  homepage "https://kamadorueda.com/alejandra/"
  url "https://github.com/kamadorueda/alejandra/archive/refs/tags/4.0.0.tar.gz"
  sha256 "f3f9989c3fb6a56e2050bf5329692fae32a2b54be7c0652aa394afe4660ebb74"
  license "Unlicense"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b679c34fb3e5daaa0769eeba9f40d8b6ff972b1f1be8f02985ba0fabadf89b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1049226c148efddf862fd4aba5e7f4bbef7720ade08d7d8ffc18dfa37f45d44a"
    sha256 cellar: :any_skip_relocation, ventura:       "4cfa926d1622e058b72c3e887024e1bc08b590da77f4ffa2052c80ab6a0f9f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc382b0b98b52ebceea6f5c8ca5fb4cca89808a85405bc9be1b1a08a4dd1de23"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src/alejandra_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alejandra --version")

    (testpath/"test.nix").write <<~EOS
      {
        foo = 123;
      }
    EOS

    output = shell_output("#{bin}/alejandra --check test.nix 2>&1")
    assert_match "Congratulations! Your code complies with the Alejandra style.", output
  end
end
