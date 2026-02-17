class Taproom < Formula
  desc "TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e4fc7e960fbb9bdca6f255f19e5edf8aa8be78925a8e36ab7b1344a7bb3dd505"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b830ae58dcd64a265edc9f5c39f5ad5ebbe65aa40ef533bd20a30b35dff94116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b830ae58dcd64a265edc9f5c39f5ad5ebbe65aa40ef533bd20a30b35dff94116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b830ae58dcd64a265edc9f5c39f5ad5ebbe65aa40ef533bd20a30b35dff94116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b76e1684c20baa381f0ccac212114275e1bf491c5da332755ba351ca50cc92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e72c36318de326da9f1691362fa0531439204520748acd2e28dd23cf81ba485a"
  end

  depends_on "go" => :build

  def install
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
