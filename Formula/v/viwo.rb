class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "5bd05ea6e02c4d6648c015c07ec527b1a0efd2165dc06a0856fea7dd68b08f93"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "7e93653f80bd7b99572b123412135c03e26de448d4c7626c28693fff9b233b6b"
    sha256                               arm64_sequoia: "70cbfc722e7151c60d2a0437cadaea972dd5f61cc2b769f5dfdf84fb97701423"
    sha256                               arm64_sonoma:  "853f2ae2a1466dd6aed2ffc1aaacd57a674ea2d72204118ee1bd396c0892aadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e5f276e85cd3107f2c8702be5502cdc7f19b77b9ff2212900da98d0a1549fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e78b6a3b732d7534bbb09f3f6365473583d1361d041c87965f592aeedb8ff9"
  end

  depends_on "chenrui333/tap/bun" => :build

  def install
    Dir.chdir("packages/cli") do
      system "bun", "install", "--frozen-lockfile"
      system "bun", "build", "src/cli.ts", "--compile", "--outfile", "viwo"
      bin.install "viwo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/viwo --version")
  end
end
