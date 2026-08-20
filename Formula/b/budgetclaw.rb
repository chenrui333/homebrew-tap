class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.25.tar.gz"
  sha256 "5dc61788681bfeb9376f661185e5bbbe8eafe8df72ace5ca9e44b4537fc21cc2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739d01029e214b0a9606de70e6ad09fea10aac5251723eb887534d3a5181632e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef37f3e69ab2b31ac774f1bb7ef1ebf151491b07ecfc872382931d63864c2c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc23d4f583d5b7db3bcfc76c5c6f8b848c4e8f363b38a9575a149d54bd552ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30e55149580cadeecf5734cc0dae092d8dde3090f020874c1e57529b2e027cd1"
    sha256 cellar: :any,                 x86_64_linux:  "f56ad3f1af3ff646e75ee70acaff17dd8d0fb28239fc340b768bdab465d33c85"
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
