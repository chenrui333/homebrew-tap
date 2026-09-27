class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3c4c075d805c99a4fac0196c31ab770d9446852a5f328b6ced23514af46818d0"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a19e6d2b69b05c442369f0856c942430ad9688f280ae065377d9bd90ffd766e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e4e64e2943fc2800049a5f1b8f39470b09904e63b7ceecd7727452b72e66bb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d291b21f67d8606ee343b162929cacd7eca1f5e6d67fabe28b9f9a16f075a4"
    sha256 cellar: :any,                 x86_64_linux:  "84c7786c5e11accb10e598eaf318bb5ab2737fe9153d300230451780fb0085b5"
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
