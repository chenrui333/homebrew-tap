class IamShrink < Formula
  desc "Make AWS IAM policies smaller by adding wildcards to actions"
  homepage "https://iam.cloudcopilot.io/tools/iam-shrink"
  url "https://registry.npmjs.org/@cloud-copilot/iam-shrink/-/iam-shrink-0.1.77.tgz"
  sha256 "f39d39712763f4d8fa6db2a1016cbe12d0456f2f34f2768b7c22534fe37807d3"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "767bea860da916221f474985b7a9010771a963174c0b3cf4f151f48b419da6b5"
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
