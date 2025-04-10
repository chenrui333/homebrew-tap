# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "0573fa9371443495117e38dab3c3604cb35f7da31bf005fd43a826976f36ea8e"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5fe36d3e31157aa0f4a5cf8cea72f6a1f8ce6eb9fecb97f197b6a26cc532ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd63933400ed7047cd3451451e8760c55e424d7083f8b75d1fb2996684bc7630"
    sha256 cellar: :any_skip_relocation, ventura:       "17f484651c7e20179dfe8ce0e63becc411b50704cd1bd25354a31a4c28a25d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9769ee85d9474e108e761e593987d8733fd81ca0bd9f3511846106cb7ff1ea49"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.treeState=clean
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/surgeon"

    generate_completions_from_executable(bin/"surgeon", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surgeon --version")

    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
