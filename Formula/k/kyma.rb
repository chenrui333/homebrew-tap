class Kyma < Formula
  desc "Presentations from markdown in the terminal with fancy transition animations"
  homepage "https://www.kyma.ink/"
  url "https://github.com/museslabs/kyma/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee2e3da492b51a352dda5c6ad9e3d6d0f8da212b1eaacce655ffb39c2986c36d"
  license "GPL-3.0-only"
  head "https://github.com/museslabs/kyma.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/museslabs/kyma/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyma version")

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
