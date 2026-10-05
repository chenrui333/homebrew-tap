class Lazynpm < Formula
  desc "TUI for npm"
  homepage "https://github.com/jesseduffield/lazynpm"
  url "https://github.com/jesseduffield/lazynpm/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "841583d686fa55872a4136627c0bed9d15edd6f87989a3a64ff7b28a0784254e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d062393550072bcbb8b538f29278dec51287b82d62885b9aa8342d0f90e837f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d062393550072bcbb8b538f29278dec51287b82d62885b9aa8342d0f90e837f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f2f07ec26ff037f4b5de835ef6b857d406e47cf68b2b214fee53349c08756f"
    sha256 cellar: :any,                 x86_64_linux:  "0ce61fea87a228227cf109f5300b300fb520b30d7629cfc4e7cffe33de4a6303"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.buildSource=binaryRelease"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazynpm --version")
    assert_match "gui", shell_output("#{bin}/lazynpm --config")
  end
end
