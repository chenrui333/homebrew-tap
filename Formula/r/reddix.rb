class Reddix < Formula
  desc "Reddit, refined for the terminal"
  homepage "https://github.com/ck-zhang/reddix"
  url "https://github.com/ck-zhang/reddix/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "35a134cbe0a80f4df3c3931b1e9546553c37ee6caa41f48c1925e8a70946a41b"
  license "MIT"
  head "https://github.com/ck-zhang/reddix.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "285464d1c3ea1e84398d4ac1e65a2e9f5b4beaa8f81809cf897426b5ed6d7477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "131bf90dfed128c5465c3249a8d66534613d65359e9a142d4269eef84bb0044c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3592f840f9b78776ed463f9369dd28a46a71089614e2da6be4a3b6cbb3d11574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62b9a0994c0b5f9c081d9247de5a37613d00e7c3f7050eec1e82b18cbc97f606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89152bade198f9ace8ab59f381b35472fd1055a00c293374f11aec490f2d14c5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reddix --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"reddix", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Browse Reddit galleries without leaving the terminal", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
