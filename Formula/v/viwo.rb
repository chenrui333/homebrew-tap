class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1c216ceb05deb428500b89a34f2102df74c1806cf54bfefefce1b63bae1751cb"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "3c052fd751878965fa7a6dd01a5f61738fca425b25246f45aaffb3a7bb4fcb48"
    sha256 arm64_sequoia: "10317b80f01750c7bc9d8f2ad5e302e41859d0a749c96a05002cc3e6a037d851"
    sha256 arm64_linux:   "24c2a118480c29535af7aab12a94c0f023b0de562882d864a0fb5e21df56e015"
    sha256 x86_64_linux:  "4db5a284b5670330534578b0bae53b1d0c541fe7d41d5f3a0d53ce25ea5ca3ac"
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
