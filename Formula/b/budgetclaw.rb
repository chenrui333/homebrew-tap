class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "1f2f7e2237ac2781fc91b9f3e9885645eacb93825a41aa134a1923a11d6ff5a2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3124aa529bb560a5b400d6b37c3bf31c3ef34cd00cc016f6f74e483273c8f051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8985adb68686bcb9a1c11ddf0c348f6fc641ff3911e072e6018ad3bd43b2ec41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662f482bca77ee94a27db7e4aba7b94c3f713971e4b10dac3389b8a148c93cc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a04a5a4bfd1484e55c04557f2744e1e3e12cf025c1302abe7446648851fe50"
    sha256 cellar: :any,                 x86_64_linux:  "9aaa83243697887f513a3ad9f640ac87820d998fce0ee11c0a4a4eeb1d77fec4"
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
