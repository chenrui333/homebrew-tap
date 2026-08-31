class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.38.tar.gz"
  sha256 "3062dea1543a3b226f2a72bf49458c9fb4f299b99b18b56dc3d296f25ad66340"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2e8976184a53010c9ab8ef5d584e8d46338658ea0340b7166a8a025a27edded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c15853e81e1ed524a9eee0d547337e7577a7e71952a3c5d4e89b2b9595d9be7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "729305545591f24793cb3bd179bcdcb02c7957aa466f3ca784b831adc65781b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdd414e9c6f9304610e326c86a2de395ae14b4b5d8741fff57c7cf4331f517bd"
    sha256 cellar: :any,                 x86_64_linux:  "e61c6491c4ff59058c321edeb7d4feb0ff3a843570657b28646318e82da7049c"
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
