class Nuls < Formula
  desc "NuShell-inspired ls with colorful table output"
  homepage "https://github.com/cesarferreira/nuls"
  url "https://github.com/cesarferreira/nuls/archive/563f6e1e96766fc1dd6983de420e785648f01e16.tar.gz"
  version "0.2.0"
  sha256 "27a71ce5947d452af92a0c92ff97b7c5b0a191f0673721accf67e5ca3a5cb14c"
  license "MIT"
  head "https://github.com/cesarferreira/nuls.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"foo.txt").write "hello\n"

    assert_match version.to_s, shell_output("#{bin}/nuls --version")
    assert_match "foo.txt", shell_output("#{bin}/nuls #{testpath}")
  end
end
