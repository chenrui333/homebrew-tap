class Nuls < Formula
  desc "NuShell-inspired ls with colorful table output"
  homepage "https://github.com/cesarferreira/nuls"
  url "https://static.crates.io/crates/nuls/nuls-0.2.0.crate"
  sha256 "24fb69fbb3ca465f6e051d36c75867f9fbe3e358eedb931fcb65125e4946e08e"
  license "MIT"
  head "https://github.com/cesarferreira/nuls.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a6ff84e2cd55fa58aa298a3cd5329fc4810f284578dddaa506ec99e8027eef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c876a6edb22c185563aea97d2c3ef5ef4bfc35ef056b83183ddb93582962c0df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe32c75b18cc3b9a4963da34878d0d9a5daeca08a2cfc2eec6c9d2f38f0cd8db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8d0d9936e4684d30fd22b7865fde3d261d38e59aaeb2296536fb08ac7a09cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "211519d0136cd0f66c8ef4c19702ed1451fbec38562f2b826ea413e2c7fc8e27"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write "hello\n"

    assert_match version.to_s, shell_output("#{bin}/nuls --version")
    assert_match "foo.txt", shell_output("#{bin}/nuls #{testpath}")
  end
end
