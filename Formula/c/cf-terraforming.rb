class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "a60037470a637b7bb81e5b345a182d8907aafdbf8ab7836d8817b5e2e6496228"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e8f03ddb1ab0124f8d5b5309ed94069e7cbd5630384e11214290946ab3b595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "117acdae075f69d444b396b5c53a050fd92f8fddf97fd473838a86534514a9a4"
    sha256 cellar: :any_skip_relocation, ventura:       "640bffca47271f47c56bca4bdf94bbef3e81ce34a1c3eb574701f43193973b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241cc201c758cd2131eb22266c222e7189807339a374343e07048140d03b4d4e"
  end

  depends_on "go" => :build

  def install
    proj = "github.com/cloudflare/cf-terraforming"
    ldflags = "-s -w -X #{proj}/internal/app/cf-terraforming/cmd.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cf-terraforming"

    generate_completions_from_executable(bin/"cf-terraforming", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-terraforming version")
    output = shell_output("#{bin}/cf-terraforming generate 2>&1", 1)
    assert_match "you must define a resource type to generate", output
  end
end
