class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1c216ceb05deb428500b89a34f2102df74c1806cf54bfefefce1b63bae1751cb"
  license "MIT"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "63151488808b2aa846cbcbb6d89ec3b45ad8133749d46213a1f798e60563a37b"
    sha256 arm64_sequoia: "998859d93522b6a5d1f30b49e81daa19c936529f28a90b911a5d2cc568cd32df"
    sha256 arm64_linux:   "b1ef79d2803fe559f6b68b00ba21bd1cc0e9ac91e91c7ab6648b8466c3d34db6"
    sha256 x86_64_linux:  "ed87f9604ba0e16428b0e4acac80ea92cf9bca3da7d15cc6f4baf2a5a94f9ba0"
  end

  depends_on "homebrew/core/bun" => :build

  on_linux do
    # Bun-compiled executables link ICU dynamically on Linux.
    depends_on "icu4c@79"
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
