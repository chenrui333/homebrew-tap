class IamExpand < Formula
  desc "Expand IAM Actions with Wildcards"
  homepage "https://iam.cloudcopilot.io/tools/iam-expand"
  url "https://registry.npmjs.org/@cloud-copilot/iam-expand/-/iam-expand-0.11.44.tgz"
  sha256 "32ae36c16e40d59ac9c3e8edc18dd471d6c34816f09e934d7819d6e67d2bfe2c"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "7353bf4ea3a3c6a046dbcf69df0c9486a385ca22937551e7ee1c9852e843d40f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iam-expand --version")

    assert_equal <<~EOS, shell_output("#{bin}/iam-expand 's3:*Object'")
      s3:DeleteObject
      s3:GetObject
      s3:PutObject
      s3:ReplicateObject
      s3:RestoreObject
    EOS
  end
end
