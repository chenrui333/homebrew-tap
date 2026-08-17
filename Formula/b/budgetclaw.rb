class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.21.tar.gz"
  sha256 "f4e1aa369a808c24aba9e115bba92aa7c32f1b8b1cd3292217a215e0500022a9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b125bfe3327517a5fd2ea3053745f37bb2aef672901b53762bedf5fc6ec3cd85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b38172711ee3529bc58876d2fe0a5edb7be39fd5b25f69c42c7e0ef1ac971a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb246ec43ab32715721f1d196cd4b10f7ef1f05527f682eaade7779e89d3c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03e98211041373fa3c532f9d628cbec5c81ee65dfe9a0f1239414fcf8586a128"
    sha256 cellar: :any,                 x86_64_linux:  "01a43b3edaf41701efa5e0d6269fd6dd1cb9ff415bef7a5e2e58d3c01bb7e6a3"
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
