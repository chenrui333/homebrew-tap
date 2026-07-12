class IamExpand < Formula
  desc "Expand IAM Actions with Wildcards"
  homepage "https://iam.cloudcopilot.io/tools/iam-expand"
  url "https://registry.npmjs.org/@cloud-copilot/iam-expand/-/iam-expand-0.11.75.tgz"
  sha256 "1975eba0b63f77c295df0ac3c0dae76432d3d904f9720960d207b8352a7a3791"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "5f679931cbfd46264c72817e3e63980c2aaec45303a635a7659db528ebc860aa"
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
