class IamConvert < Formula
  desc "Convert JSON IAM Policies to other formats"
  homepage "https://iam.cloudcopilot.io/tools/iam-convert"
  url "https://registry.npmjs.org/@cloud-copilot/iam-convert/-/iam-convert-0.1.86.tgz"
  sha256 "ce183622b49372025280e497821ec5bfa84e6b27cb6486a9408a27488829c281"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "39bbccaff8eb89d516ae41eebc8d24996f4f8c044aa03ce54a10a28edb59231e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"policy.json").write <<~JSON
      {
        "Version": "2012-10-17",
        "Statement": [{
          "Effect": "Allow",
          "Action": "s3:GetObject",
          "Resource": "*"
        }]
      }
    JSON

    output = shell_output("#{bin}/iam-convert --file #{testpath}/policy.json")
    assert_match "data \"aws_iam_policy_document\" \"policy\"", output

    assert_match version.to_s, shell_output("#{bin}/iam-convert --version")
  end
end
