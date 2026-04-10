class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "4cacda066d120a4f7480c80f708aeb3fd5d6890833d8e693246e47200c197145"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f16487a9e8e2a06a3b99ec7e3c7978642dba37529a00d0f77dcd03ca5b46777e"
    sha256                               arm64_sequoia: "e210ee4eb9c8d5a300e88b276b947c3bf1651690eed0c77e6f631395a5f4f189"
    sha256                               arm64_sonoma:  "45ad9db072fd9da8c9076f490f2735e9c7d853115db5285b456f0b6f4758208e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16c978d9c8229e8b92558726d1d8902aee010d51cad625e44b00b0c9c50f352d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab538bc5ef135cc0827bc4f122fb9714bc43bf90dcda1743b9b9b00a71a36ca4"
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
