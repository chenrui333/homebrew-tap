class Lstags < Formula
  desc "Explore Docker registries and manipulate Docker images"
  homepage "https://github.com/ivanilves/lstags"
  url "https://github.com/ivanilves/lstags/archive/refs/tags/v1.2.23.tar.gz"
  sha256 "43ecc6b925e85cb6656b0114cc1404611cb5a4c50e0eeda80bcf5727ebf8c187"
  license "Apache-2.0"
  head "https://github.com/ivanilves/lstags.git", branch: "master"

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
