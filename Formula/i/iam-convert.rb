class IamConvert < Formula
  desc "Convert JSON IAM Policies to other formats"
  homepage "https://iam.cloudcopilot.io/tools/iam-convert"
  url "https://registry.npmjs.org/@cloud-copilot/iam-convert/-/iam-convert-0.1.37.tgz"
  sha256 "4115ffc38f16555632b0db85d279313acbd6d8eedf349423e128c0599143e3df"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6acb7471498d097dde316b4ebcfa76b1bea5a5c9563431b4d16246d13aa748b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4589de3119f12990a2605c48b49b5dc5e61c3fe682bf33f5f09815afb2974da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "986f4b43d1188886d62b79455458463ceadae09c629e94757f18e46ee42541ed"
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
