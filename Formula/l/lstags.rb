class Lstags < Formula
  desc "Explore Docker registries and manipulate Docker images"
  homepage "https://github.com/ivanilves/lstags"
  url "https://github.com/ivanilves/lstags/archive/refs/tags/v1.2.23.tar.gz"
  sha256 "43ecc6b925e85cb6656b0114cc1404611cb5a4c50e0eeda80bcf5727ebf8c187"
  license "Apache-2.0"
  head "https://github.com/ivanilves/lstags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11cb7960b6a206ddbf46205cc88c24e0e8c2f5f6a3777535182ff10604c17898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11cb7960b6a206ddbf46205cc88c24e0e8c2f5f6a3777535182ff10604c17898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11cb7960b6a206ddbf46205cc88c24e0e8c2f5f6a3777535182ff10604c17898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81d7981820c6e3d1ea3aa162082a1120845c15db642f900645b3c00d72c5331"
    sha256 cellar: :any,                 x86_64_linux:  "06dd09708e66a537b5fc741f02e0f80e167adb3eef8632cd56d7352d138a4088"
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
