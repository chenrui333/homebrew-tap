class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "09d92d02dcea8bc43cd8b58a3369b349f4af0007c4e750ff16f91362000231b4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "141689d4227c60e3956b8f498456136ef6fe2c66b91aba56f9b8ad6031573a5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775dd263a84251fc3f72385b72a258ddcf8c976eb0496e4389aea542a278132e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79f06a752dbc91335ace7c48c1a2c4113d4f6634c7e0767551a3034231e7f73f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad09512fd730481ba59bdcd9428095ec5bc1f21c9aa8f443a42401334fa19a58"
    sha256 cellar: :any,                 x86_64_linux:  "b811a70c08e8cb59c073c12b30fdead18f4e737a6249b52c24f009d2b7b8440f"
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
