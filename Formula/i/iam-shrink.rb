class IamShrink < Formula
  desc "Make AWS IAM policies smaller by adding wildcards to actions"
  homepage "https://iam.cloudcopilot.io/tools/iam-shrink"
  url "https://registry.npmjs.org/@cloud-copilot/iam-shrink/-/iam-shrink-0.1.89.tgz"
  sha256 "14724690dc6f8ff1fdf5844c882aee48fb1770e49a7cd091a4223531627faead"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86fb6409f1a73a9e0eb93d935532b669afd2392d731c0140f2ef4611c371d5d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86fb6409f1a73a9e0eb93d935532b669afd2392d731c0140f2ef4611c371d5d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e41d8c2012294f8d8e984008a6e9dcab3e19f5f0fc43c6a5db8057a3fc6475f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e41d8c2012294f8d8e984008a6e9dcab3e19f5f0fc43c6a5db8057a3fc6475f4"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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
