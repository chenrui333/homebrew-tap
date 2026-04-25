class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash.cli.rs/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "645416f29f5af7c4a9a90b69e9803d37dae1061b5a0cf141393310cfb4d1aa5d"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c1a5b85be10fcfffcf4464ad0667b783adea877cdc49ddb840ad0294c3c1dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32addae0ea30ae6ba76a6c6caac68dce645e6871e9bd9a815504ac45a47df9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad8c33dc4fac6438c3215ab19cd4e409b196a7d39f74a0364c9f576b5ed6c5a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a574f2e6d80763b592f77b7859e649c605210b658f520e230fc2fa581f043a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5c3228bf32cf8749bebe22e55a63af3b1f41c406435a70b9147d4b86d8aac5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    # failed with Linux CI, `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"kdash", [:out, :err] => output_log.to_s
      sleep 1
      output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
      assert_match "Active Context", output
      assert_match "Resources", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
