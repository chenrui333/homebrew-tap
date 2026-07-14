class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "9c5cf834d022e14d9ee35df953aeb58ae0480f1dc456a6616c1280c01ee16392"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3bd8c05c6409339be56072091295ba0aa6e691d4b793a1f18ef558fb2ad4979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3bd8c05c6409339be56072091295ba0aa6e691d4b793a1f18ef558fb2ad4979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3bd8c05c6409339be56072091295ba0aa6e691d4b793a1f18ef558fb2ad4979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "464cea750bee7b93a30787881b7c6bcf39abf383857f9996b873fe21503c3f01"
    sha256 cellar: :any,                 x86_64_linux:  "9d9df5de759e3a0066e93c8861444df49987b13ce6f99c80c31d170f45bbc34c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
