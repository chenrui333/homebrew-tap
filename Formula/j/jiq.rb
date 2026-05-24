class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "e6efca1293fef122e38111703355216b738688b6a671ab5d311dd54559e4759c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb8205cbdbb09c0314c98fd82a3c26f2fa7da7f5f1a4c6ec151fdefd2265d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92d577957a6ef97a029590f89bc792efb6377ce56dec78ab8f9e0132090e8d3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f71dfcea89397843950005b906395d6cbbbaf96af0148174f64b396a8067cf67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d0440d4a77411702f8c483b6dbbf53ffc9ba7bae8dc18966be4c496a4cb6372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8347f64c922e7128469fbc04fd6ed335a8829a076197ca591a99bd959e0a9957"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
