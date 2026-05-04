class IamLens < Formula
  desc "Google Maps for AWS IAM"
  homepage "https://github.com/cloud-copilot/iam-lens"
  url "https://registry.npmjs.org/@cloud-copilot/iam-lens/-/iam-lens-0.1.120.tgz"
  sha256 "663c2bcbffaa14424794cc9b824cc7f214dfd4aeabf2a67dd63e72c1701f1b8a"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b56417619983a0f2797feba820350f4e2bd84ebe6e8f019aa482e80f0b11ee7a"
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
