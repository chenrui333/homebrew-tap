class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "cc1b41192a21d16352d93c012682176723da0551080f1bd5e3d77b8b7aed3da1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3dc67d2e57f163aeae61992e199bff8d796b4f146e4123bfdc5853ad371bd72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3dc67d2e57f163aeae61992e199bff8d796b4f146e4123bfdc5853ad371bd72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3dc67d2e57f163aeae61992e199bff8d796b4f146e4123bfdc5853ad371bd72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e24d4033959017ab55de1d80d540ce457dc2d921eece04de5afa500fc05b5413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292dd4e1a540b9cdf0ba1aaf236be5078486e7786016c5b7e76a19b2bef6def1"
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
