class OrgFormation < Formula
  desc "Better than landingzones"
  homepage "https://github.com/org-formation/org-formation-cli"
  url "https://registry.npmjs.org/aws-organization-formation/-/aws-organization-formation-1.0.16.tgz"
  sha256 "a3d4be909939bb85b033886bbf8913ffe20e0946ad62f19a0169e2cfc8811406"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ace4c98cebc9c0da6a4a67b38f8fd04f3e0cb45ce8fa8b4da5e609827e76444e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "032746d59f8dfae760329bdea9b6f831be2afb31693fa4dd1fc2505fc9417e1e"
    sha256 cellar: :any_skip_relocation, ventura:       "3fa19f653c2500f396a2d2dbd0e7eb4def907c833b28b9263568c118c01a9192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cafa2cf8c394e619b0f58177148271f90dde3699760794272076761142e3ac4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/org-formation --version")

    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/org-formation init test-init 2>&1", 1)
    assert_match "The security token included in the request is invalid", output
  end
end
