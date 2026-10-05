class Httptap < Formula
  desc "View HTTP/HTTPS requests made by any Linux program"
  homepage "https://github.com/monasticacademy/httptap"
  url "https://github.com/monasticacademy/httptap/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dc6b99f20b1ab33f6801050a2367529a235c2b1a654d24f908b1f1bf62a36457"
  license "MIT"
  revision 1
  head "https://github.com/monasticacademy/httptap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d6f42c3f268e28f8595f30d037645bca254c092dd40225e964aa716928cbfe66"
    sha256 cellar: :any,                 x86_64_linux: "3aa86cd8bc7a381d91cfc4de29304c12d4e8b3c0374eba6f73e01cb8578f0bd5"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Creating the user and network namespaces is not permitted in the CI container.
    output = shell_output("#{bin}/httptap -- true 2>&1", 1)
    assert_match "operation not permitted", output
  end
end
