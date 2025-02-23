class Ferret < Formula
  desc "Declarative web scraping"
  homepage "https://www.montferret.dev/"
  url "https://github.com/MontFerret/ferret/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c6170136012dcef52d4f20e226f8f4625fdb31519433a52d95a37a1c0d15d85d"
  license "Apache-2.0"
  head "https://github.com/MontFerret/ferret.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6878d25aa613f045e1f8546c39322a1c96b1b01e40c0f2962417c639520c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4438d2a6f6e8eea6649be794eada2a05569502d5935e1c97d1fa204a5bc5c14"
    sha256 cellar: :any_skip_relocation, ventura:       "cb1a3042c7824f510921c17fe7b7abdf767730bdc7852bac8b7a8f8f441c285b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f050c30450c8032d0e05a14592fcbf15653c8ad5bf32509549bfe6bfad7a86"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./e2e/cli.go"
  end

  test do
    # seeing different behaviors with Linux CI and hosted runner
    # use macos test is good enough
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.fql").write <<~EOS
      LET doc = DOCUMENT("https://www.example.com")
      RETURN doc.title
    EOS

    output = shell_output("#{bin}/ferret run #{testpath}/test.fql", 1)
    assert_match "Example Domain", output
  end
end
