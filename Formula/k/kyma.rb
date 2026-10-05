class Kyma < Formula
  desc "Presentations from markdown in the terminal with fancy transition animations"
  homepage "https://github.com/museslabs/kyma"
  url "https://github.com/museslabs/kyma/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee2e3da492b51a352dda5c6ad9e3d6d0f8da212b1eaacce655ffb39c2986c36d"
  license "GPL-3.0-only"
  head "https://github.com/museslabs/kyma.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2347b6ed0d16d4a3652bbc5548f6cd54357bba486f3cfbded5f512d0339cb86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2347b6ed0d16d4a3652bbc5548f6cd54357bba486f3cfbded5f512d0339cb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d22e4b650bd58083a7eb31ecbd1a1dbe0dd05c5f826ce7ef4e329829d6d59e6"
    sha256 cellar: :any,                 x86_64_linux:  "d48ba0a3457b82a09b43b6efc5c7735bbf2ba6d218ac9d742761b1b8a15610dd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/museslabs/kyma/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyma version")

    # Skip test on Linux GitHub Actions runners due to TTY issues
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      (testpath/"test.md").write <<~EOS
        # Slide 1
        ---
        # Slide 2
      EOS

      output_log = testpath/"output.log"
      pid = spawn bin/"kyma", "test.md", [:out, :err] => output_log.to_s
      sleep 1
      output = output_log.read.gsub(%r{\e\[[0-9;?]*[ -/]*[@-~]}, "") # strip all ANSI escape codes
      assert_match "# Slide 1", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
