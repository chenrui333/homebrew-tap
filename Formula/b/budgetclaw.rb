class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "f141c6670f090a3a6e12f9d8653ac74c7677b41b205ddafc060dbd6517005b52"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "913885cf13621aa5f343261c8d0d8aa4900fe78ef7dd1230103787d21e3ca1ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05a183179da61e2ca29b8c9cadb534c5a7402a456f385792acc4aae18dacd13d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80745b402148dc80be6cbc816f5a256ff66d67741b73181ae1f3102218d10d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f7bd28711d1fd09398859082f444201a632f2d4b25da89858e7c519ff6b7b42"
    sha256 cellar: :any,                 x86_64_linux:  "c770886bf507ee6b3a516935f249f3f7ad3bc3407f29fe0704d1546d6ee850ba"
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
