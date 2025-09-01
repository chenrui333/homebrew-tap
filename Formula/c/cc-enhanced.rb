class CcEnhanced < Formula
  desc "Unofficial terminal dashboard for Claude Code usage analytics"
  homepage "https://github.com/melonicecream/cc-enhanced"
  url "https://github.com/melonicecream/cc-enhanced/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "07110940672bb86e2c74c1e265741b8c60d603573f8c7d851dafbeb9f71ed201"
  license "GPL-3.0-or-later"
  head "https://github.com/melonicecream/cc-enhanced.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"cc-enhanced", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Updated OpenRouter pricing cache", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
