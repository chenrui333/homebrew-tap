class Lstags < Formula
  desc "Explore Docker registries and manipulate Docker images"
  homepage "https://github.com/ivanilves/lstags"
  url "https://github.com/ivanilves/lstags/archive/refs/tags/v1.2.23.tar.gz"
  sha256 "43ecc6b925e85cb6656b0114cc1404611cb5a4c50e0eeda80bcf5727ebf8c187"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ivanilves/lstags.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ccb35ac46890e6fef371cd9418b2ee905da36136c4b918f0bd2c8521a7f5d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e60e1996ae2654d361d1c9f3160cbe0ad5f9c70efc5ad25147d0e21e461bb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a718b885f6a517edb165b1070423bc2d1b2e9dd456e0ef2a4cd4b2001339ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca330fc96a6190f9c7cb6839df270f988dca63268f39ce1e2af0248144cd8bb3"
  end

  depends_on "go" => :build

  def install
    inreplace "version.go", "CURRENT", version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lstags --version")

    output = shell_output("#{bin}/lstags --dry-run ghcr.io/linuxcontainers/alpine 2>&1")
    assert_match "FETCHED ghcr.io/linuxcontainers/alpine", output
  end
end
