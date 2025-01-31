class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "94361d74241fe79803d7981b51294fd252a5d337359ca3147d68061a1d144b46"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb87cc1aead5b6ac35bcc74b34e990714da04b60b8ea63b8926281a08db2eb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72e0156a7e9be50d85723da28510d900117409e2b3d617048a0a474bb9f382f2"
    sha256 cellar: :any_skip_relocation, ventura:       "8ed1ce7161f333f72464c6e2e9211c1273e5a980d6b9f753d298007b2ddbf879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe57430fea19ce9efca3e998ed53fe2814d6c480f6b0783ba5e91f3fdcbac2b"
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
