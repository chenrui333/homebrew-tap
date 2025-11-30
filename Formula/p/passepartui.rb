class Passepartui < Formula
  desc "TUI for pass"
  homepage "https://github.com/kardwen/passepartui"
  url "https://github.com/kardwen/passepartui/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "a0f518ff699a88f721ac9d90646aa3e8c82f99acdb58d915dada317d8fd1fa95"
  license "GPL-3.0-only"
  head "https://github.com/kardwen/passepartui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23c9f743a3758f88d6e760517ba670db6c598cb2e8f8aea02e8f4eae06683203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "590c9c6fbf9d4e0d91f446f9dc0de8b4a545666efc8ae9e6e7af1003e65f6d87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21b8e2e3c2278dbf3920e66f4d4d63e80ca56848daa67c7c50659e2e4c2cb04d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eed7ddab649012cf405241a247c6b1ec50ad6054cd85e22fe6349423d3782ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d4122cecca8d0f10036f036d01a22e1a9829afb48049cc684587db94ac8b5a"
  end

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
