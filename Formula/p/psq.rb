class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "07e21c21fa950341451081383dd0e04eb09bae01dac0bae2d1743bc155df27d9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf4cbad82b6e271cf7c42f1eefcb39cb1c716b6b8da3a4d4dc56784d3f5e88ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4cbad82b6e271cf7c42f1eefcb39cb1c716b6b8da3a4d4dc56784d3f5e88ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d61b1a1e6b47f954f3bbe379c1b36ddb79d2f93e6f5f2ccadcc2cf1f4f2a9077"
    sha256 cellar: :any,                 x86_64_linux:  "f9d18257765a07ffb0435a14e6b7501acbb9ccc8c4786a56b5eba6c57dc056da"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"psq", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initializing", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
