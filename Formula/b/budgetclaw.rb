class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "0171ae7144fb69795a14434abb0c2a6e9568447c5967982b60e71e2e010a889b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaca5b9d46367d542c7d207a652b3dcc5188d4ccfd04070f3951962ff4bc6498"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f70145d6524a22f6b1bdfa640dd844b8bfdaf51beed4d469956a8197e3b031b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0568dc7d628ba4d73fe47c9451081de377d3e6b90887f58fc424709c249f1815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2c91731bbd98e181cb64a98dab00ae15d0be66532313e649fe21bd7127949ee"
    sha256 cellar: :any,                 x86_64_linux:  "b9878500bf190a8c6e3759ced88d5e8ca6e7795f4f9ed1c437430ed8cd2f846e"
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
