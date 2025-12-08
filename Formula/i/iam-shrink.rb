class IamShrink < Formula
  desc "Make AWS IAM policies smaller by adding wildcards to actions"
  homepage "https://iam.cloudcopilot.io/tools/iam-shrink"
  url "https://registry.npmjs.org/@cloud-copilot/iam-shrink/-/iam-shrink-0.1.50.tgz"
  sha256 "8db9044f121c80fb05e93868ce5b6c189c4d238ae3e00865b1b3d8f4300383bc"
  license "AGPL-3.0-or-later"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iam-shrink --version")


    output = shell_output("#{bin}/iam-shrink s3:GetBucketTagging s3:GetJobTagging s3:GetObjectTagging " \
                                      "s3:GetObjectVersionTagging s3:Get*VersionTagging")
    assert_equal <<~EOS, output
      s3:Get*VersionTagging
      s3:GetBucketTagging
      s3:GetJob*
      s3:GetObjectTagging
    EOS
  end
end
