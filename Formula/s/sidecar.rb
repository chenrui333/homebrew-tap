class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.99.1.tar.gz"
  sha256 "f947e5a652ad4b2bb42283f79d4f0e59afeed7e6eeac37d329dc6d221e869d94"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9089a450bd1f56d0c6490f302b5420d1e8dfdf6d479595154cb3875e3f111632"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ac55f555325117f33b21f47721c1b8add758bcf6b21c677fc97cf07f5749ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6df68f453339dcc30050432e1b205973a4e4c10b0c305b303a2b531658bbc69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39821ef9e78a8a8ae5f713f7aa5aadfff57a7336292f880570b4bf3dc493856e"
    sha256 cellar: :any,                 x86_64_linux:  "95ee94881a336ac37f19075ec3336ac641c72f973e9fdcead230cc92167fe69f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
