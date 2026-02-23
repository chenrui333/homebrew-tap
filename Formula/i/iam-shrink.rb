class IamShrink < Formula
  desc "Make AWS IAM policies smaller by adding wildcards to actions"
  homepage "https://iam.cloudcopilot.io/tools/iam-shrink"
  url "https://registry.npmjs.org/@cloud-copilot/iam-shrink/-/iam-shrink-0.1.60.tgz"
  sha256 "2cf6f4365c3df0792b9b674bb7d12f096e2f435d6abe907a243380413c64ac14"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "8333b55664501d833cce6006d97a858e462957974a9198865457149b2cdce5fd"
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
