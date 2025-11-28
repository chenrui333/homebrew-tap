class Kyma < Formula
  desc "Presentations from markdown in the terminal with fancy transition animations"
  homepage "https://www.kyma.ink/"
  url "https://github.com/museslabs/kyma/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee2e3da492b51a352dda5c6ad9e3d6d0f8da212b1eaacce655ffb39c2986c36d"
  license "GPL-3.0-only"
  head "https://github.com/museslabs/kyma.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7758ed6765248967e7f3f43213f4a7e80093456d7c0850bfa2ee686199e9854d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7758ed6765248967e7f3f43213f4a7e80093456d7c0850bfa2ee686199e9854d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7758ed6765248967e7f3f43213f4a7e80093456d7c0850bfa2ee686199e9854d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6787dde00f22f7b187aab8ea96c994427309ee9482e153450363704d184634e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a93f884cbe38c3c67efea37948700fd26e6ef3c666585e81f8db59dadbc0a370"
  end

  depends_on "go" => :build

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
