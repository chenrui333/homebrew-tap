class Rustfilt < Formula
  desc "Demangle Rust symbol names using rustc-demangle"
  homepage "https://github.com/luser/rustfilt"
  url "https://github.com/luser/rustfilt/archive/refs/tags/0.2.1.tar.gz"
  sha256 "f09bb822c8b22c4c89bf63cc64f8f85a053e1850a70cad4b7308e00871527496"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustfilt --version")

    assert_equal "foo::bar::baz", shell_output("#{bin}/rustfilt _ZN3foo3bar3bazE").strip
  end
end
