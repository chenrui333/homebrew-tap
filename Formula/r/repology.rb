class Repology < Formula
  desc "Command-line interface for Repology.org"
  homepage "https://github.com/ibara/repology"
  url "https://github.com/ibara/repology/releases/download/v1.10.0/repology-1.10.0.tar.gz"
  sha256 "2d918ab0525415b5a4b2920cd2814411815b58b2d94a310eba31bf5e8a954257"
  license "ISC"
  head "https://github.com/ibara/repology.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd47ba1124fa91872d5490f078d8ab79a396a99e30ccdd58e4c57160ee7ac57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f86287084b9b8ebcdee3293ab69da653706fe571b7ddb34801d5056b8810cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e668bb54e070597e77492c322ce3f1b7c90c38b65111cfed33207107427c58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ce2e2827d3dd333c98a27474ac44d832787bfffef1d86c7c17ee1801ed0e69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf7cabe083cd20aae08720dcbd67c4dd9d23fb886a1752cb8921a54a3cf964f"
  end

  depends_on "ldc" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    bin.install "repology"
    man1.install "repology.1"
  end

  test do
    output = shell_output("#{bin}/repology --help", 1)
    assert_match "usage:", output
    assert_match "--search", output
  end
end
