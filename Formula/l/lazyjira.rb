class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "c01de954213fc18bdc26b40e5a44791683abec00c56104e2f9907b258d36c34b"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2063303cb3cd363b922818d0b425695b209d36f55a46b0233dbcfdb7a36f77a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2063303cb3cd363b922818d0b425695b209d36f55a46b0233dbcfdb7a36f77a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2063303cb3cd363b922818d0b425695b209d36f55a46b0233dbcfdb7a36f77a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e300aa41d075f06d29465905ad429b8d15398d494b1143031f728e9e0ccf671a"
    sha256 cellar: :any,                 x86_64_linux:  "48770871bd6074cc50cbf49ab099d3aca938f68063e62f0c6ca66200afcbf576"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")

    output = shell_output("#{bin}/lazyjira auth </dev/null 2>&1", 1)
    assert_match "host is required", output
  end
end
