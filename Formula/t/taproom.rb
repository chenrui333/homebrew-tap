class Taproom < Formula
  desc "TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "85ee7660bb76ed9277573d2c856bcfebd3181b919edf3862e7f9e15d32097088"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "849f8beff4f9a66be27677667030c9f9a47c7b5b4465537a9c758f3d5f00d13c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849f8beff4f9a66be27677667030c9f9a47c7b5b4465537a9c758f3d5f00d13c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849f8beff4f9a66be27677667030c9f9a47c7b5b4465537a9c758f3d5f00d13c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa34ef3f17c07123bdd5bd5f00d28319692838ca47e8d9a61006be437b8054bd"
    sha256 cellar: :any,                 x86_64_linux:  "d8beee0c51921e9171e4bf538b17414ac5e766632ddbe80ba7d4919931dd8f97"
  end

  depends_on "go" => :build

  def install
    # v0.6.2 predates the upstream version-file fix: https://github.com/hzqtc/taproom/commit/a26afac788a5122356bf9c07c3c3d04fabae76d3
    inreplace ".version", "v0.6.1", "v#{version}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    # Skip test on Linux GitHub Actions runners due to TTY issues
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"taproom", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "[1/6] Loading all Formulae...\r\n[2/6] Loading all Casks...", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
