class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "0171ae7144fb69795a14434abb0c2a6e9568447c5967982b60e71e2e010a889b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0827568d74a38cdf4230fce684818e6c12940910c2998558448de4e43f9e3452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02e8a23bf9433755334bccdb6c2c3abf4197c609be86e420efcc0c8920ac96c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6e0a6d04767b831b3e6678680e95183b8ba82250193ac313ffc74633f116f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bd7d969c303fe45fd634d6c9e5a5fe7bf07949d79ebbb62783786d401ac1e04"
    sha256 cellar: :any,                 x86_64_linux:  "29219a8b14f4a6161c329bac8b23aa1d0a097de7c07259bf015316d46120dc75"
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
