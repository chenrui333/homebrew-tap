class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1c216ceb05deb428500b89a34f2102df74c1806cf54bfefefce1b63bae1751cb"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 arm64_tahoe:   "e1e3ad2f5472efa4eddfd272c2ffcfdd78bcf218ee56dd75b6771a35a5481038"
    sha256 arm64_sequoia: "257f07f5951a596d9e063244ac5b3f96876c68ade8f00c0bf497d60e3ba11ec1"
    sha256 arm64_linux:   "8e0ec661ec918d02255720f6945c67d0eac24a67c6e6751a351d2bae5aa99bab"
    sha256 x86_64_linux:  "20c8ac5be564fb6f88b1e812c8079799f382bd79f9a01663958c2611571b2a0e"
  end

  depends_on "homebrew/core/bun" => :build

  on_linux do
    # Bun-compiled executables link ICU dynamically on Linux.
    depends_on "icu4c@78"
  end

  deny_network_access!

  def fetch
    cd "packages/cli" do
      system "bun", "install", "--frozen-lockfile", "--cache-dir", buildpath/"bun-cache"
    end
  end

  def install
    Dir.chdir("packages/cli") do
      system "bun", "build", "src/cli.ts", "--compile", "--outfile", "viwo"
      bin.install "viwo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/viwo --version")

    output = shell_output("#{bin}/viwo not-a-real-command 2>&1", 1)
    assert_match "unknown command 'not-a-real-command'", output
  end
end
