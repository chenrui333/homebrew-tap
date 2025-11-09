class IamConvert < Formula
  desc "Convert JSON IAM Policies to other formats"
  homepage "https://iam.cloudcopilot.io/tools/iam-convert"
  url "https://registry.npmjs.org/@cloud-copilot/iam-convert/-/iam-convert-0.1.44.tgz"
  sha256 "a031efa14aa546a28b4d4e89c73bf24f897ee4e5febeec667b50dce366d19fad"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4643e4f745f3d0137ba327a8f43ab8b6d505721359c2da9664dd177ce0776b4d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
