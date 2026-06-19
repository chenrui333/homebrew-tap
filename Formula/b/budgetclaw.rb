class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e906ff66ae1c3063e2efa24091253c398c901d467f6d4fb526ff27a5b114f404"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99c37f138549a57d9365b449883dd0e81f73373f61225f3d240819ad245fb4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f679350c3208758eea25aa12163d564f92e840c83c1ce7844f6f1c82382302fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11c07414a4dc3a07c4099c01b8a1bb9747d8ee8e3d229ff1426f9f09eefcc3c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b26e55bc049a4555a405a52f99ac099136f74d33d8c491005196c9613e1fa5c9"
    sha256 cellar: :any,                 x86_64_linux:  "e5613d999e0a7e61193735452b2e0ed0476dcc60a9ba43047cc57b123e3c4c36"
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
