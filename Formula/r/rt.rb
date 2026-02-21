class Rt < Formula
  desc "Run tasks interactively across different task runners"
  homepage "https://github.com/unvalley/rt"
  url "https://github.com/unvalley/rt/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "82d1daf1f16517502fbb7011d287bcf6eba649c6dd8a1f3c9a97212dfba8ac45"
  license "MIT"
  head "https://github.com/unvalley/rt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09cf97269ac25645e61746cf9e2618459018f57a101fc16b7eb43e3d922a2716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a63931f0fe7f82a4dfe1e7383f8c3a79cc76d41e1278cd22f29ce95550882768"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "315ca561be406ecfd6a53fcb992b2421cf026b9ddb852d584585df3aa1e71811"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54df232fbc8c9278a8fb1a00f76509211cd1070310e02b93a98f4718371820b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ba6ff599f3ef5e6952ed8f016b6f9b691043eea0c4a8fcf216e0143c0002496"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rt --version")

    (testpath/"Makefile").write <<~MAKEFILE
      hello:
      	@echo from-rt
    MAKEFILE

    assert_match "from-rt", shell_output("#{bin}/rt hello")
  end
end
