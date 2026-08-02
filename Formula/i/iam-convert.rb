class IamConvert < Formula
  desc "Convert JSON IAM Policies to other formats"
  homepage "https://iam.cloudcopilot.io/tools/iam-convert"
  url "https://registry.npmjs.org/@cloud-copilot/iam-convert/-/iam-convert-0.1.83.tgz"
  sha256 "3e11b30674d12f85a12d573392eed0552db51b97ffa160adbdc91ff7667864d8"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "2768ce6141cd6e66e6469ec4496f247b91927df5edce3b906fd57d70efc21ee6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "test_policy_json" do
      url "https://government-secrets.s3.amazonaws.com/secret-policy.json"
      sha256 "6348c4060ad668b8cc14aaad21fd426ca2bffb3002fc11abb89ab4279439b409"
    end

    testpath.install resource("test_policy_json")

    output = shell_output("#{bin}/iam-convert --file #{testpath}/secret-policy.json")
    assert_match "data \"aws_iam_policy_document\" \"policy\"", output

    assert_match version.to_s, shell_output("#{bin}/iam-convert --version")
  end
end
