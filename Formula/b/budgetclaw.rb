class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.18.tar.gz"
  sha256 "1cd18b10d117ef5adeea3383ce159529fde8840a5b0a063c0ea0c48f926991c5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a138d2c19966cdf0da90d9c872d9f94e1ff073fb1bdca490eef40f90aa08dee4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ba6a0b4dd0a9ca5e3cd42e4235c3c2d3a8bd6a7a9009a779648ac2766f9375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5334d51471614bf3156477b623ecd48eb8a7f398b7420398f60b5ddc7a8614f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd7a4563e1d9766cf54acc9790c4741bf62e16f1235630e24620b66fffea8e70"
    sha256 cellar: :any,                 x86_64_linux:  "4d177d7dd12aeb8ac84dfcdb2ebabf437cdf6c9d96492d76a8817a3723fcc384"
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
