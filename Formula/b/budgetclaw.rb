class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.23.tar.gz"
  sha256 "11d3449b8ef1f0ef656357281492047d291661006328c49500ee4b57f88d8a83"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a493d641ab465de55dc93c2cbd92f5ac17e975a69b03a78baf5eb3fa5727fe76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2369130ad78fb62b2463838acf48bc211d57c7b1b3b48b3d652672f7e94fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ad3eb03f66c308359c57b6a7f997a49c1ec8b2950d5e7dae4f4e996b4b8808c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c437c9feed56d0ad701e4e6b554cdba7687007a0b187f3f95a558d26abc62246"
    sha256 cellar: :any,                 x86_64_linux:  "d8d1cba41ce298ea1399051e85cdbb781e4159374fd197c758883b9151c3429b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end
