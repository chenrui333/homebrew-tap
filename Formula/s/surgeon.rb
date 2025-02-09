class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "77441dd33a183716b2fed34a76c0dc613731123d938d7fa81e7592bb0a3e4014"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3998de9aa8e5872210f5fad95e0f03b925d6e07e921b98a5dc7372ad185d3cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eae1232d473117277580df197f575cce660bdd0c30ac93579a0c4c527949677"
    sha256 cellar: :any_skip_relocation, ventura:       "c2d68b1efda7a916ab3711320d30cdc0076c1aea3d88b17401c3ba7c304b034b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0046a7cccbd36311bdced1eaf2e85a42d6ca240d826c082454daa6e4da0bd89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"surgeon", "completion")
  end

  test do
    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
