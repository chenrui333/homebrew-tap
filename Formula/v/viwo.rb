class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8e4456587a57115aa239cff0ddefd7861c07de9efb408de6fc2a2e008ef09c3c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "5fc6679f31f062ca276c479ab84c759be5e719b34ed2cf17b6d77f0aca771c58"
    sha256                               arm64_sequoia: "97020eae2517cdc745c9657ae67e8154e6f1a117048a608d468862dc7e1e8590"
    sha256                               arm64_sonoma:  "6c9ec037d0ae2a4fea2bd73256e669b9cb0808732481f8d5c57f8a0b420c5d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e67c681d7d82390618d47cf1396a6f0d6b8adc070439089d8ba920ee6f4e2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0726c34590e2513e28da8f244602474240a2f53b2459902f1dec8fa01946071b"
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
