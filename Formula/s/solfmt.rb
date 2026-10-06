class Solfmt < Formula
  desc "De-minifier (formatter, exploder, beautifier) for shell one-liners"
  homepage "https://github.com/noperator/sol"
  url "https://github.com/noperator/sol/archive/7762c5115dd899bfac10d2f46d066de3c0e81774.tar.gz"
  version "0.0.1"
  sha256 "e72473ad928528216d98107275f7a402cae5f36f8fb0c65032ebee5c19e04f61"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ee60c05f600c8ae0d57623c3cd44568fc449e49d21d3fb072559c5f60299221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee60c05f600c8ae0d57623c3cd44568fc449e49d21d3fb072559c5f60299221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569cc9c2d3cf158ab594eb772aba8bfb666e2bf7bdd449812913de9483ebe9a5"
    sha256 cellar: :any,                 x86_64_linux:  "3fdcecc2284687e0012064589aa5459535a9e411b654ae00747dff7f0cdff0ca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"sol"), "./cmd/sol"
  end

  test do
    input = "echo hello && echo world"
    output = pipe_output("#{bin}/sol -b", input)
    assert_match "echo hello &&\n    echo world\n", output
  end
end
