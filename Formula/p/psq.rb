class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "cfee078ce51b3e9d7907994d137568a421ba926a071be5224e198d1fab5271e7"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c522ebb9210cfeb28edba8b42b6c90fdf170230e8c97fe56ae39a37fda7cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c522ebb9210cfeb28edba8b42b6c90fdf170230e8c97fe56ae39a37fda7cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2c06c2ce97316906781b0fa9e6ce75ec2a60151226236d6df7128dc325abf78"
    sha256 cellar: :any,                 x86_64_linux:  "22d0b87a120edcdfb08e88937c12f24a63f30378240eff3b593727f8a388a42d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
