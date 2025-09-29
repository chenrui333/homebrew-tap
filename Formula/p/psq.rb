class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d17d056ec599452024829709b2942d1416af2e62d47babc9ed387122118617db"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "436a452992f6c3921b85822bc0d46e32dcc78813070d27843aa31e6d11032f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb19b4db061a62d34ed26d213e22dc193cc8ef24819e699a51c4624e261ead95"
    sha256 cellar: :any_skip_relocation, ventura:       "119b1a6d1e201066410a41c17979e832f676a6683b626b3f0ee9b981f0e01389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30d37a56001a1fd48f1ba68e645a2e175daf72f54b44809ca47d3ccb8639c5f"
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
