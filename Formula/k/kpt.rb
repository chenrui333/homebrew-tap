class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.61.tar.gz"
  sha256 "308e809ac79c5cc72672a0119a654805ee151a94659542166194d1660f69c4c9"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63daef8310a81522f7e9ffc4b044ebac08ecf39913b5976f1613fa10143af8ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d81618a8944cd8bffc185fea24145c7989221c0dee73282e3d918d379961e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "233a23c68e50f6f48507034b3bd12b63793833feb9d5aa4eee4330a17307b525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44cf4bec6225d7539fec46d674917363154a40554973a4be350e99fd7e258b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ea811a79c7e97dad36ff9c71b6b96ddf5b9754c633f88dc813e8f982392c383"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kptdev/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
