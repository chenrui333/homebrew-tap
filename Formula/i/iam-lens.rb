class IamLens < Formula
  desc "Google Maps for AWS IAM"
  homepage "https://github.com/cloud-copilot/iam-lens"
  url "https://registry.npmjs.org/@cloud-copilot/iam-lens/-/iam-lens-0.1.151.tgz"
  sha256 "69d69a523fc8460d121486c94ad3dd5b023a25f35fa55cf2e4861e947748a5d4"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a89bceb123635e5648ea351c5be1e52ef582c0ebf738f342d8915bf0de8ab6ac"
  end

  depends_on "iam-collect"
  depends_on "node"

  # Preserve npm's env shebangs so the JavaScript payload stays platform-independent.
  skip_clean "libexec"

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
