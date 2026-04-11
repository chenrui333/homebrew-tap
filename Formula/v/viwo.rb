class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1c216ceb05deb428500b89a34f2102df74c1806cf54bfefefce1b63bae1751cb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "446fd69d78e709ca635523d48a849603d352e8342e98429d4300ef6c562296f6"
    sha256                               arm64_sequoia: "d82db450d6b74bf25e2e3b187dc5e93774f861ec1f8bac1ff5dcba65cd4d0491"
    sha256                               arm64_sonoma:  "15a52b3e04ea10e2ffc15c51bea7a6dba306653b244e3b4ad4422268d0b9e1e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0914bd9b98998f96fdd04599b060501852d13bd9dcba2f31590f886968954b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671f2ac3a6d293c689d3a2a1a2e22578266a5f62c3e2f3432879afb28d2e3437"
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
