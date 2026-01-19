class IamConvert < Formula
  desc "Convert JSON IAM Policies to other formats"
  homepage "https://iam.cloudcopilot.io/tools/iam-convert"
  url "https://registry.npmjs.org/@cloud-copilot/iam-convert/-/iam-convert-0.1.54.tgz"
  sha256 "143c65de3dbb4b02f9fab2a4ed73d883f5746023191426390ae799ea7ab1bfe2"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b4e0a2c646a741371957d9570ee36a600aacf8c4ed4a856158cfe56d43e41f23"
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
