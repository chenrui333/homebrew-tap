class IamConvert < Formula
  desc "Convert JSON IAM Policies to other formats"
  homepage "https://iam.cloudcopilot.io/tools/iam-convert"
  url "https://registry.npmjs.org/@cloud-copilot/iam-convert/-/iam-convert-0.1.35.tgz"
  sha256 "e35061262a2f4d7fb2cfa9ab577ce0569e65b3d150a0a76ef9baf885aae703c2"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "036eb566398d594a5c3ba1b40db1aa00190482259f122ed8dacb30bfb67d5d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34f789b20eeb188244790a77df9d391bdd18dc65137b0b2b45323a8705a50cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa4db3fc0a5c1f087f222f01ac21344f8a19de9d1176769f444b161d012d32c4"
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
