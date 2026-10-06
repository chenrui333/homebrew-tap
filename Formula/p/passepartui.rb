class Passepartui < Formula
  desc "TUI for pass"
  homepage "https://github.com/kardwen/passepartui"
  url "https://github.com/kardwen/passepartui/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a0f518ff699a88f721ac9d90646aa3e8c82f99acdb58d915dada317d8fd1fa95"
  license "GPL-3.0-only"
  head "https://github.com/kardwen/passepartui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3753676cde49ceadd5a3c08ed2526f317d461949ffd44ab1ede3b4b3b67391ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af002222d94547cea0c3c1ab2d18a2dafda14436b45165e96d89985c974877b"
    sha256 cellar: :any,                 arm64_linux:   "4fc370a0a2545a7123aa749bf13e9712c7a71cddff6ae1d6bd5b4eb0078a5aaf"
    sha256 cellar: :any,                 x86_64_linux:  "7433e92c329079422858364ba5020278414b63837a438ad503af06be437285bd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "pass"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # failed with Linux CI, `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"passepartui", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Password file", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
