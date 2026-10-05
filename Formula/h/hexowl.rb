class Hexowl < Formula
  desc "Lightweight, flexible programmer's calculator with variables and functions"
  homepage "https://hexowl.ru/"
  url "https://github.com/DECE2183/hexowl/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "c80e419d8936b610d414f374f909d3dc5dc6b53a95ebf3589ecae6618814fed8"
  license "GPL-3.0-or-later"
  head "https://github.com/dece2183/hexowl.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e102e162b3686c304fe5bb91cb442b745292b3f2489c27b9744d0f4cb8c2ec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cf12e6654189d1bb925573c56e0198c82cfbb8481ae752f34682ebe4a3345b1"
    sha256 cellar: :any,                 arm64_linux:   "0787934ecbd2620286430daac37cdaafb8ae3bcd24880243bfc289a6f622841c"
    sha256 cellar: :any,                 x86_64_linux:  "496b04f9b2e405ed4d7858d2031d586810f8f2959195a5ef1a906b41fe42fdad"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexowl version")
    assert_match "funcs", shell_output("#{bin}/hexowl funcs")
    assert_match "0b\e[38;5;32m101", shell_output("#{bin}/hexowl 2+3")
  end
end
