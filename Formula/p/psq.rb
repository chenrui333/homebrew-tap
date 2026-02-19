class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "7006a3db8660b2240707ffb9cb923fccdff29e1cd755a647801b04c1b2929ba8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73ffad1f0a800388207ebf09ed18b1b6bd24b686816444d6f199e02e9c50dc48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73ffad1f0a800388207ebf09ed18b1b6bd24b686816444d6f199e02e9c50dc48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ffad1f0a800388207ebf09ed18b1b6bd24b686816444d6f199e02e9c50dc48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f72a9eafd2a6a3c01826b89189b05eb071a4232490499c6da6f5d7f69b64a531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8afbbeecef6b47772155e636b0eaecbd3590830118907881396850558cfaa518"
  end

  depends_on "go" => :build

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
