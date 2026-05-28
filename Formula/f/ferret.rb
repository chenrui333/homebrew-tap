class Ferret < Formula
  desc "Declarative web scraping"
  homepage "https://www.montferret.dev/"
  url "https://github.com/MontFerret/ferret/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0219ac8940fee9911b362ea0e6eed2849115eb59d745176e08dd912ca01f8796"
  license "Apache-2.0"
  head "https://github.com/MontFerret/ferret.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e06ca819ec9f278e2339b85f022b00ec093a3e7d5ed25771fcb9992f8b6612d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e06ca819ec9f278e2339b85f022b00ec093a3e7d5ed25771fcb9992f8b6612d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e06ca819ec9f278e2339b85f022b00ec093a3e7d5ed25771fcb9992f8b6612d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c6c2616f6aa38fdfcf2835ffc52db1db6ba1802389d3408bc38da1e6e0bc633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98640d3f2ae14fa01a339a97c2e27ec1b0df9b73b8226c7ae9a86770377b14af"
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
