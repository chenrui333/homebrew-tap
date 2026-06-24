class IamExpand < Formula
  desc "Expand IAM Actions with Wildcards"
  homepage "https://iam.cloudcopilot.io/tools/iam-expand"
  url "https://registry.npmjs.org/@cloud-copilot/iam-expand/-/iam-expand-0.11.72.tgz"
  sha256 "335d9777d98b7d1fc0739910af2157a213ed15f9f2b397ca3572f6f8a91b2522"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b62d72f755ec0d67cebeb248d546d5347e477c5fe2798e6320636fa91dfd44a7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
