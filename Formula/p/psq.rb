class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "c9a3092bc21bca1b7663c178f1ceaaadae6fc78a47df862f58eb94875391645b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166c5af7380831965294984ef83241d81b264ed1c41973e58e2f964a904c37d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b227ff4e08169d1489a7ef7c243bfae452e958c55a3b5f42cb4bcee962346976"
    sha256 cellar: :any_skip_relocation, ventura:       "6990aa4166c293a90486e0b5c60ef73d2ee139cbcc3720e75f65c4905f1e662e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8b009695f2d453300e4a28f55cd9052039e67af7730031c735e1049a10eb1d6"
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
