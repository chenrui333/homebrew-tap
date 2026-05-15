class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "68f2d2e4bd2276383fa988de924d24b09093f226db067b67fbe92e99334dcc15"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cb46107784f8001cb1b0e1646e5b42fccfc87d37b0cea1b5c0b4cd981ed6859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb46107784f8001cb1b0e1646e5b42fccfc87d37b0cea1b5c0b4cd981ed6859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cb46107784f8001cb1b0e1646e5b42fccfc87d37b0cea1b5c0b4cd981ed6859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b9406f7285d809b99fed08d9641cbb71ac1faa83ce241b844ae92113e9dcd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db8dfce3fa571a694f095b4672e1e6bae0a50a6058b2d1631e7bc63619c8f66"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
