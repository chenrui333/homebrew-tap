class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "553675e674fbc5a0d7043e5b1ec5cb10d971b0772ef759e6934f1b872654fda6"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a928e9ed29a364c49bb274e5a74c51d046f43f064f34e0114dbbc247f86938f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a928e9ed29a364c49bb274e5a74c51d046f43f064f34e0114dbbc247f86938f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a928e9ed29a364c49bb274e5a74c51d046f43f064f34e0114dbbc247f86938f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f36bbb3e752dd0feff5a2a2f7dabc5d38eafe6002c10a7df08437f8015eec0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d722e2de49c14f35565e28cab31e577a114b21e9863b054772d21e3591916e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
