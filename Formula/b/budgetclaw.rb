class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.81.tar.gz"
  sha256 "26ffb4e10ffa76267abd1efba5f05d6fcd69f9e548e469667acef22712f7f4a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08329c0dfa541f0985fe413cc474b0d0a0f99c493157c4f61f626b5edb1948d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f73bf879543c59d91237b4963d5f49f42c8a92e570227d70f8fb669baf78d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5413bbf0eaea4ddb7b78f9cc75b37e57fcddb6b988538ac21891492697e1ef6f"
    sha256 cellar: :any,                 x86_64_linux:  "580d0ea8e60b87fc70b7bccb2bec67de2f59995b608cfa2e9d8523e8e931761f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
