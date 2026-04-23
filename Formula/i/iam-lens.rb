class IamLens < Formula
  desc "Google Maps for AWS IAM"
  homepage "https://github.com/cloud-copilot/iam-lens"
  url "https://registry.npmjs.org/@cloud-copilot/iam-lens/-/iam-lens-0.1.116.tgz"
  sha256 "e9f7a4368ff59a922bd527001f4381e6e178302550163bb64e27fb40783f68d3"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "6aac1772b3d225cfe1730df6b7cb9e00cb1fc28d4d80d21cf6b525af8d5f6919"
  end

  depends_on "iam-collect"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iam-lens --version")

    system "iam-collect", "init"

    output = shell_output("#{bin}/iam-lens simulate --principal arn:aws:iam::123456789012:role/ExampleRole " \
                          "--resource arn:aws:s3:::example-bucket/secret-file.txt " \
                          "--action s3:GetObject 2>&1", 1)
    assert_match "Unable to find account ID for resource", output
  end
end
