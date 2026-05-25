class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "553675e674fbc5a0d7043e5b1ec5cb10d971b0772ef759e6934f1b872654fda6"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dda472a0e3c4cfe03d09c5a349517a2934cc444039d926a5b3078ed89ce3b5ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda472a0e3c4cfe03d09c5a349517a2934cc444039d926a5b3078ed89ce3b5ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda472a0e3c4cfe03d09c5a349517a2934cc444039d926a5b3078ed89ce3b5ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7f1c8946f6761d5f7c06ca18809eca621b14b76fd42bbd66fbaeb3b947480d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc32d919b7b6b1f1b4b1561e93f9d7163bb9e28fd52ac6a058ee4633892e129"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
