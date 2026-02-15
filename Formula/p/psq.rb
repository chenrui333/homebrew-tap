class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "38537e0a4cd30b01dcc2ce144829ecab9ff8714e26339f312354f6122eafe6be"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdf94834e7660417b6f4fda441742d6e74cd43a5d6bc977b16dd137f5edc6915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdf94834e7660417b6f4fda441742d6e74cd43a5d6bc977b16dd137f5edc6915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdf94834e7660417b6f4fda441742d6e74cd43a5d6bc977b16dd137f5edc6915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e10390f370d15005586ec530e6ccc84b2f2afa3775b961b9c51d616f310d8c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78ecf6fd33ef458a993f76b5d26eaeaacff41492445ccd1adc29309aa4f41fe4"
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
