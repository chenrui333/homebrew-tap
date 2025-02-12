# framework: clap
class Alejandra < Formula
  desc "Uncompromising Nix Code Formatter"
  homepage "https://kamadorueda.com/alejandra/"
  url "https://github.com/kamadorueda/alejandra/archive/refs/tags/3.1.0.tar.gz"
  sha256 "35a56a8619e79fccd10fe64176afaa291c6539dc3be1136bc9e72639523fbc0e"
  license "Unlicense"

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
