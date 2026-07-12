class IamShrink < Formula
  desc "Make AWS IAM policies smaller by adding wildcards to actions"
  homepage "https://iam.cloudcopilot.io/tools/iam-shrink"
  url "https://registry.npmjs.org/@cloud-copilot/iam-shrink/-/iam-shrink-0.1.82.tgz"
  sha256 "9ac300851f2c7c40bf9aef4f91ea08908fc6d3754b8d8351ca3e0d15860acd7a"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a9e465d6cfdd41524894a85d3ec0b5bee42d0d0b0f795fb80000a76eb16a5765"
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
