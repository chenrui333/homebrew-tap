class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.57.tar.gz"
  sha256 "614f03e30064a58872c0e0eb356a4c05501909e3c56c985912d44bd47d3f3944"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882da51089fe11c8637d96ceed0a54bdc5f5328dffdfe6fe1a717e12b9d82544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2dd6fdd596d867d54a4bda3c81d0e446a569e9b8411910b6ae384ce3c28f27e"
    sha256 cellar: :any_skip_relocation, ventura:       "31fdb6beee34ab3f3c709ad37f529b849815be7df7c4d4b7929f7fe859dd59f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4e1453df55214af8bb90fe3f2c1fdf3dfcb20850ddfca2bef8687bc710bb62"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/GoogleContainerTools/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
