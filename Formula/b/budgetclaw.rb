class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4456afc2513d995079127a8a7058e3dc78b372bd6c2e44c7ae41c38b4c745ce9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dccec6452180cf0874c764bcbe7f8cce97bedd38772b33d6d4885ea34ce2fa0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da338e65408c39f995934c9cbe09ab173a5859240d2e584b5b34fc92f44e5b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bc6107381af5689e947523a4a3c52f7b95471084b6f111cfbeba1154831e562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a6370fc33a2d089994a9beb46448f5835917dabf4e67eeecd426d2692669aff"
    sha256 cellar: :any,                 x86_64_linux:  "f0743af0ace79021fdec9db5e61e1fa29d4317f9d2e83b7a204cd7202f615a7f"
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
