class BinJq < Formula
  desc "Jq for binary formats"
  homepage "https://github.com/wader/fq"
  url "https://github.com/wader/fq/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "9f668394c33f3effd02b7d7a145f1087ce784e01d3d0c6e6ba41a899d5e349a7"
  license "Apache-2.0"
  head "https://github.com/wader/fq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "071695f80b8e6bdb51b505aa5ffb570eadc50f23815adda12777a73281c1486f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d344100d7636268e895cfa1d9d67d1f2e40f4bf762ce87ec324362d94750d9b"
    sha256 cellar: :any_skip_relocation, ventura:       "7cd0bab5aca8eeba60417c3ad28c74abea4a35140262f322e7389cbea52999c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89050f05d8166c2699d52f52f9bb746cde304eaab5f21cc1f3968aa0057f879a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"fq")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fq --version")
    out = pipe_output("#{bin}/fq -d json '.[0]'", "[1,2,3]")
    assert_equal "1\n", out
  end
end
