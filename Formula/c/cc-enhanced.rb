class CcEnhanced < Formula
  desc "Unofficial terminal dashboard for Claude Code usage analytics"
  homepage "https://github.com/melonicecream/cc-enhanced"
  url "https://github.com/melonicecream/cc-enhanced/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "07110940672bb86e2c74c1e265741b8c60d603573f8c7d851dafbeb9f71ed201"
  license "GPL-3.0-or-later"
  head "https://github.com/melonicecream/cc-enhanced.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79c1b2eddf48c456a9001c5ad39b3d49a09755377fb9a851d8a4602a86c46da9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a4d1fad5baa3f57bb6c043681eefe421c6693bd23d21d6945f94f7992f5fa19"
    sha256 cellar: :any_skip_relocation, ventura:       "df9b41d6c2b3f95e0c56a17998654470715ed50e044a7069ba35b555fcea30a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ec20c0baa6aa0308515f4c139c4f9e5da46e1c17b1f184f5603f6de6d3db47"
  end

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
