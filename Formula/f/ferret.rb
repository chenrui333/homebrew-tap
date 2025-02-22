class Ferret < Formula
  desc "Declarative web scraping"
  homepage "https://www.montferret.dev/"
  url "https://github.com/MontFerret/ferret/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c6170136012dcef52d4f20e226f8f4625fdb31519433a52d95a37a1c0d15d85d"
  license "Apache-2.0"
  head "https://github.com/MontFerret/ferret.git", branch: "master"

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
