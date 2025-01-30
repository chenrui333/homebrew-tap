class TerraformIamPolicyValidator < Formula
  include Language::Python::Virtualenv

  desc "CLI to validate AWS IAM policies in Terraform templates for best practices"
  homepage "https://github.com/awslabs/terraform-iam-policy-validator"
  url "https://files.pythonhosted.org/packages/13/7b/4fba4bbee1931df373f456a34994a1f089059ac13bac5ade29e1ae143956/tf_policy_validator-0.0.8.tar.gz"
  sha256 "f43359ee0478f10e7b27a3fb7282c284304615cc6f06fd5aa3aa631edbe4811a"
  license "MIT-0"
  head "https://github.com/awslabs/terraform-iam-policy-validator.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "8b217c9010613ada7e9d02267b1b46788eb21b278cc47364648269c580c44370"
    sha256 cellar: :any,                 arm64_sonoma:  "78b9e7cedd583b11bfc5b9091517caecc5166844da10fe82ee7c35af04a32f56"
    sha256 cellar: :any,                 ventura:       "f2d5aace6b8f73cdf904fe7b91a83d82b39c2de3d7e7025242f379d9b47e3fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b6954a3625ffbfb7983b5b4a6c6fe7b95510a12d8899057c5ada277ad13842"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/01/36/2e445688adf538259f469bd1f415619959df2aa9ac2972df8a5728791898/boto3-1.36.9.tar.gz"
    sha256 "035ed3868ff3b9afe05a49d0bde35582315bc438e60b5e76727a00b107567bfb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e9/1e/976c79eeac461ddbf64b27ce42788c1f26e111c138bb931d14b4062127e5/botocore-1.36.9.tar.gz"
    sha256 "cb3baefdb8326fdfae0750015e5868330e18d3a088a31da658df2cc8cba7ac73"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/45/2323b5928f86fd29f9afdcef4659f68fa73eaa5356912b774227f5cf46b5/s3transfer-0.11.2.tar.gz"
    sha256 "3b39185cb72f5acc77db1a58b6e25b977f28d20496b6e58d6813d75f464d632f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"default.yaml").write <<~YAML
      # Provide minimal or dummy config
      settings:
        example_key: example_value
    YAML

    (testpath/"tf.json").write <<~JSON
      {
        "format_version": "1.0",
        "terraform_version": "1.0.0",
        "planned_values": {
          "root_module": {
            "resources": [
              {
                "address": "aws_iam_policy.example",
                "mode": "managed",
                "type": "aws_iam_policy",
                "name": "example",
                "provider_name": "registry.terraform.io/hashicorp/aws",
                "values": {
                  "policy": "{\\"Version\\":\\"2012-10-17\\",\\"Statement\\":[{\\"Effect\\":\\"Allow\\",\\"Action\\":[\\"s3:GetObject\\"],\\"Resource\\":\\"arn:aws:s3:::mybucket/*\\"}]}"
                }
              }
            ]
          }
        }
      }
    JSON

    output = shell_output("#{bin}/tf-policy-validator validate " \
                          "--config default.yaml --template-path tf.json --region us-east-1 2>&1", 1)
    assert_match "No IAM policies defined", output
  end
end
