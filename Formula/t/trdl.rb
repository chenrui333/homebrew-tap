class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "a6d905e1394fa7a8d307c971984d9f2dac16f5093612597cf77c24dcda762b74"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b4e91339cf237ec7e1798325264a8420a5812c3bf97218214e030ba17809e92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4e91339cf237ec7e1798325264a8420a5812c3bf97218214e030ba17809e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b4e91339cf237ec7e1798325264a8420a5812c3bf97218214e030ba17809e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "731a18f82fc1f19f06904f01b01c7f27de94c9c250a0f7cb7b63d8d9f7321922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8260834679d8a96e04cfafb3263a5052281f6d16c39a61a3a60649325eb6752"
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
