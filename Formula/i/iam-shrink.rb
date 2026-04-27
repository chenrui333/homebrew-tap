class IamShrink < Formula
  desc "Make AWS IAM policies smaller by adding wildcards to actions"
  homepage "https://iam.cloudcopilot.io/tools/iam-shrink"
  url "https://registry.npmjs.org/@cloud-copilot/iam-shrink/-/iam-shrink-0.1.70.tgz"
  sha256 "e72f64d2730779dfd918282be05a3bc74d3706c91de7d7722edefa0acf08660c"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "2e725825ce3e547020e30818f814fefb0a6436a8df7a3ca4b4bb0a8a01297beb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iam-shrink --version")

    args = %w[
      s3:GetBucketTagging
      s3:GetJobTagging
      s3:GetObjectTagging
      s3:GetObjectVersionTagging
      s3:Get*VersionTagging
    ]
    output = shell_output("#{bin}/iam-shrink #{args.join(" ")}")
    assert_equal <<~EOS, output
      s3:Get*VersionTagging
      s3:GetBucketTagging
      s3:GetJob*
      s3:GetObjectTagging
    EOS
  end
end
