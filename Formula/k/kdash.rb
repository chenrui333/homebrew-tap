class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash.cli.rs/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "645416f29f5af7c4a9a90b69e9803d37dae1061b5a0cf141393310cfb4d1aa5d"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8365d13278f1f6cf3ae5563933d9f49bebd437fd89b2c5275280cc1132f53c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2fe92da299cfb5e490dda919c4d5384d2ba9847b90264c4b7569c2bf5bd6f45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fe4ddbc2d0ce689f0e5ce70cf93f29a492234a0bb7e1122d4d935cde542cf93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff7b8e867c660f24611004dbf857ccb4c720e40db0d21486f2385ac24cfccf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4684f25c660801291d55d86d4c0ad339b0d4907e832c6c240447ea7052ffe640"
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
      assert_match(/Failed to load .* config/i, output)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
