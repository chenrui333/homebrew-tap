class Zuse < Formula
  desc "Sleek, minimal IRC client for your terminal"
  homepage "https://github.com/babycommando/zuse"
  url "https://github.com/babycommando/zuse/archive/refs/tags/v1.0.tar.gz"
  sha256 "6ae04f645216981462f913049db1916d2b7761bf14e5c5259fc77d42582ddbda"
  license "Apache-2.0"
  head "https://github.com/babycommando/zuse.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a8db3d30cc0e9c91b26d0a1a36dab2fc803313554f8ed57d7df4cd789749fac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8db3d30cc0e9c91b26d0a1a36dab2fc803313554f8ed57d7df4cd789749fac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8db3d30cc0e9c91b26d0a1a36dab2fc803313554f8ed57d7df4cd789749fac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c028af4eaf7d23798b7e33cfa4739010d0c423de6d5e22de6b7175d51a083dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f0c3659e74adbc747a2e0a814d62bb12f36c16b2a0b22699fc6810cb377093f"
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
      pid = spawn bin/"zuse", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "loading…", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
