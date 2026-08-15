class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.19.tar.gz"
  sha256 "f80064d90a69e12d89c04f8d182e9544918659f74b77ca00a1abe78d6e75c79d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4248cb37db0af6b3e14f549c8f4b6fce57dcb564705abad86bc4200b429ca159"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b89e5f15b6080f81ae2e673c0028483d1b7ea8b4740d42c7dda5b196761f2a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f11bdaf0fc95cd3c6349ff383cbf9b1059453b417e2e3d848b979a493c0af2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f8038b5eebaa4ccb67d6f0bcd5e61f12028af9caee6b42bbe745fbbec29d116"
    sha256 cellar: :any,                 x86_64_linux:  "57d245b933c9777d5b86077fd65816ea31d220c05397ff47d11afe15ee80c655"
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
