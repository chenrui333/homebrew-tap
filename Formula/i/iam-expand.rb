class IamExpand < Formula
  desc "Expand IAM Actions with Wildcards"
  homepage "https://iam.cloudcopilot.io/tools/iam-expand"
  url "https://registry.npmjs.org/@cloud-copilot/iam-expand/-/iam-expand-0.11.46.tgz"
  sha256 "5f781cef0115f4eb9cfa1e7a2007e1f9a1e6dd5e688fe81b4cfc729a638a5100"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "40ddfd190ba6f92f1f31dc19e8709050c0daafc96309ff37c9decf27684bb7e0"
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
