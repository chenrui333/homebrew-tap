class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.44.tar.gz"
  sha256 "1399a95eb94d9914af732f1b59ede66e0bb838e981cd01b2cf18c73b5d94a86d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c693e1402bc1fd527b581596cb5b9b8106bd6bd99e118a324ac42553892826fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf1da35fd4e2eb04b6b7a0e6b1329df3deac2bd3143ac2e1968d8b4f9bd576d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4463da135e7eaffcd369d22321243ba15ab9b75a861b1c24cd09944636b9dbf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1f146476905cb5284f8c032fd77bad604bf4c05050c8c058cf0368de3373b1"
    sha256 cellar: :any,                 x86_64_linux:  "e9b0b0fba76c81b9819496c15dbdcb20ce4d0ee650593e34b191a94480ca7a9e"
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
