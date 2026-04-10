class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "4cacda066d120a4f7480c80f708aeb3fd5d6890833d8e693246e47200c197145"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d08e677bdc42493b976d8d0ea66e1bfd6f6bf41074435ade1f04ccb4f511c76b"
    sha256                               arm64_sequoia: "c34ae4e1453897f85a702b62f5b10e0a3943962ed47a64e00086d468f193411e"
    sha256                               arm64_sonoma:  "2eab3811a5746b7537242119bc8fb0b68391553fe3120c192486d63631e6fc9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7a1b18dea2710b2ad0cc3d179df4090ce4d51b32eed8c44d88c9f44ce8df0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d2acb6d1a886f3f55113f635093fc829ab556e6643034572587e8208b853e25"
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
