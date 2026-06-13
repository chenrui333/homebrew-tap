class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "a6d905e1394fa7a8d307c971984d9f2dac16f5093612597cf77c24dcda762b74"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6e68433b2b096940d23718a1228819f05b648aaeb9d062745d5f612e7419729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e68433b2b096940d23718a1228819f05b648aaeb9d062745d5f612e7419729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e68433b2b096940d23718a1228819f05b648aaeb9d062745d5f612e7419729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "313af68648342f4a7af7146e7aea9abe440acaee078aa08ce468386b855838b6"
    sha256 cellar: :any,                 x86_64_linux:  "13b5683fbea196ec5c970c06132bc15f3e6978034adffdae867db9dab2ad3460"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/werf/trdl/client/pkg/trdl.Version=#{version}"
    cd "client" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/trdl"
    end
  end

  test do
    ENV["TRDL_DEBUG"] = "true"
    ENV["TRDL_HOME_DIR"] = testpath.to_s

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/trdl list")
    assert_match "Name", output
    assert_match "Default Channel", output
  end
end
