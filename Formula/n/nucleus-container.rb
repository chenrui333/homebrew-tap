class NucleusContainer < Formula
  desc "Lightweight OCI container runtime for NixOS"
  homepage "https://github.com/sig-id/nucleus"
  url "https://github.com/sig-id/nucleus/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "9e5d465c55e192142186f919de5e3b9134d4796ec2c5bf0f215ad8537cc0ec6c"
  license "Apache-2.0"
  head "https://github.com/sig-id/nucleus.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nucleus --help")
    assert_match "nucleus", output
  end
end
