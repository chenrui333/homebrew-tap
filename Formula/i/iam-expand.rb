class IamExpand < Formula
  desc "Expand IAM Actions with Wildcards"
  homepage "https://iam.cloudcopilot.io/tools/iam-expand"
  url "https://registry.npmjs.org/@cloud-copilot/iam-expand/-/iam-expand-0.11.47.tgz"
  sha256 "03e1f79b6f4392d22f09ff4ce30f8f92a6706c61573210df957bbc4aaa06f720"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "62b550a2bf0a63b3191304f9cdbe685176d0e13bfc06e04065c57071750551f9"
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
