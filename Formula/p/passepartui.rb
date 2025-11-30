class Passepartui < Formula
  desc "TUI for pass"
  homepage "https://github.com/kardwen/passepartui"
  url "https://github.com/kardwen/passepartui/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a0f518ff699a88f721ac9d90646aa3e8c82f99acdb58d915dada317d8fd1fa95"
  license "GPL-3.0-only"
  head "https://github.com/kardwen/passepartui.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "pass"

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
