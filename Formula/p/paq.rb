class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7015036560793f644fb37315da92eccf49768480703ecb47f8abc455644b1209"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b60c6ab2b0377aa892eb3aafb26c816f36031eefda3334d6ebd67985abdb4d7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0190ef360084e742e042a07690e9bf6a1da49ae9460787c4c545376f47c95ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8066a93c2c3bdf7ba34d7444be1446f04b1a717dfad45dd35e5719f716147e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30ef28525a08bfd17c8a95b710164a9ae4b9ab554d781638d5119f84d1a771ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb15ee56714e6160a55d471b1388a7355fe9cbc2eb72c2a14637aa643ee6d45"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "eb9122ffff587d1cb9e56682d68a637e8efaa6c0cd3db5d90da542d1ce0bd2c2", output
  end
end
