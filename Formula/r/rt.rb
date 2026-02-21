class Rt < Formula
  desc "Run tasks interactively across different task runners"
  homepage "https://github.com/unvalley/rt"
  url "https://github.com/unvalley/rt/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "82d1daf1f16517502fbb7011d287bcf6eba649c6dd8a1f3c9a97212dfba8ac45"
  license "MIT"
  head "https://github.com/unvalley/rt.git", branch: "main"

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
