class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.34.tar.gz"
  sha256 "5505eb27e192cddb4811ad99f2866654cc0ad172f8853bb82214ce26f127c454"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb7f5203944f46063fd015585086d1e8bdc2782e22f3f7c5dee0addd73e2aba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6327e9cf08771a0412ac0d936b3a3e000a6164a82db861874046343aef3fda67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a2ddf17247654b704b3a2e1bc01a9b38bf07c000e5ba0b6299e11f403dae124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c60593e1eff2e1c5c13e492511bfcb93ce2b140142ac47f48bd449e2c2d442f6"
    sha256 cellar: :any,                 x86_64_linux:  "ff800fdce3fded69616e94288f617ed385f705e1b5607494daf3a22426b044aa"
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
