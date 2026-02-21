class Dcv < Formula
  desc "TUI viewer for docker-compose"
  homepage "https://github.com/tokuhirom/dcv"
  url "https://github.com/tokuhirom/dcv/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c09ca4a2ddc9378316b6ed336203d38a64f329e562665319106f2c9b83f6c18d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27f5bb8769cea8b36598a70ff0d531795e64d983f3a4828f3f03e65a8a4faf84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f5bb8769cea8b36598a70ff0d531795e64d983f3a4828f3f03e65a8a4faf84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f5bb8769cea8b36598a70ff0d531795e64d983f3a4828f3f03e65a8a4faf84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccf931651abd540a3b37d900647877c3a493a73416aefda975e4e08e41d00313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17341a5704a51b3b535d3f9f616f90d7d4ffc96c4720122dbd2b62b33426a02d"
  end

  depends_on "go" => :build

  def install
    system "make", "build-helpers"

    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # no version command to check
    system bin/"dcv", "--help"
  end
end
