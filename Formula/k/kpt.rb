class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.63.tar.gz"
  sha256 "faab08a55957489345d3fcc2af75df146bdce0f6d378061732f629838b062f97"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f8595e29003340de3ab526fdda68d589b44049cf0abc766b1047a94e04b5927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a55c69c51cedcbcca446ad4b335b7376e6303c1b8ae9a7d962a86f090f7213c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a939f9999c226c9f724b5116ceb8e6479c70b68cfc588179bae09f058471f5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a76de63ba94ad4d66b3b7f16c871730c99e7272f5f933eb83730c6cc3b5300f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8612c7a831a3f6e082f7184a77a026d80b63c980c5b3b2d848165bd390978d54"
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
