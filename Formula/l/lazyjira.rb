class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "7a7d2d3852ae1d4d32c2a9501406570cbc1066e7276eb100bf56f88df9352ca3"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2abf3c1f89cc1ff2fcae636c76dd506c1926db9e92091092699e0405ad271c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2abf3c1f89cc1ff2fcae636c76dd506c1926db9e92091092699e0405ad271c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2abf3c1f89cc1ff2fcae636c76dd506c1926db9e92091092699e0405ad271c4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18545069f9f0d919aa015a16c6756324b500bcecb844152d662b372336d49780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b604e116777bfef84fcc1d63f24a3b7e924b8399b3f037469a79dfc78c42556"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
