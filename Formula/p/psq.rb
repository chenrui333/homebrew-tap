class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "c9a3092bc21bca1b7663c178f1ceaaadae6fc78a47df862f58eb94875391645b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018607b1c6d363629fae8c5d02f4905f9981f1d8efdcb476e478716d9aab6efa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd5424ba01ccbe1e747ce293ad63ce9f821241c16ca2b9722bcd3dc9414ecb9"
    sha256 cellar: :any_skip_relocation, ventura:       "ea6257d28c6a9dd2636ca2521d8f91bdd2664813fe815501a3a4ba3c61308009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eaf5708a89d195d138d3e7aaf53ee5bc0f19743ffb773cf4d34e8957bab6a78"
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
