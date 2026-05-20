class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "4e1f8264f47c5359efe195ed8bba152261ffc83b0fe94ddb0bf83bcc40db6581"
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
