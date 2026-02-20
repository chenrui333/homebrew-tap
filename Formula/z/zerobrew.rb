class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "efab8d6171751bdea6ef17b028d9dafccad45ff1252874ab2f1e6f87b4c2bdc1"
  license "Apache-2.0"
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ad46f9925db2246d407f680844cfaa924efbe922f41e4f6d08fb51de3f4366f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5600e973f59d600931e2e63ead23d2c9e7d2687ec1fbaaaf54bf95c322d043bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a74ff9738e4c87ada24e9e6575be383d1aed9c7a525e8015a5f9ce9a35acf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7257112d4faa655e1589c3edeaf3904d5bc9e4262569d26b02987dd8bf90cb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81ac0fe934ccb3b20ad03973e7ddff4a1cbed67baea7a52db3db1967808c3052"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
