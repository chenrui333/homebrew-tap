class Ferret < Formula
  desc "Declarative web scraping"
  homepage "https://www.montferret.dev/"
  url "https://github.com/MontFerret/ferret/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "65dbdde0b2ba962fcf51d1ebcd5f691b323fc0d55813c3b395e58cc4104ecd1c"
  license "Apache-2.0"
  head "https://github.com/MontFerret/ferret.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72e5001d1d5846aaab5eb2e262dcebb9de1c9c9359e13bb5b811b44718a20fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "413c66a184c2d178fd4bba09493bbbf03031ca5b31ea2b7ae1cfcd1ea2a60c0e"
    sha256 cellar: :any_skip_relocation, ventura:       "b0a01ed4e4bd896f6b535151a44872a52f47aacfbef6abbb268cc552b1e21330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9eb51cb886100e474062a529d3bb9b0e41d632a6c94b72c682cca1469117487"
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
