class Doit < Formula
  include Language::Python::Virtualenv

  desc "CLI task management & automation tool"
  homepage "https://pydoit.org/"
  url "https://files.pythonhosted.org/packages/5a/36/66b7dea1bb5688ba0d2d7bc113e9c0d57df697bd3f39ce2a139d9612aeee/doit-0.36.0.tar.gz"
  sha256 "71d07ccc9514cb22fe59d98999577665eaab57e16f644d04336ae0b4bae234bc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4211d31f917e7edc18f665cddd2e0427c1c78490bb5d4ce27ba9203f502b6a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c9e576fb7bf6f7899e1e7641b812a50fc8d6f50d0b9a7c63b3e2255003540cb"
    sha256 cellar: :any_skip_relocation, ventura:       "c375e05df943a2048b32e5c059ab79917eebb8c33e3757a7adda55d84550d037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4941aa344f927ddd8ae9f01aed29eeb6d6ee71b6bdb3ddfafcb066f70ea34f"
  end

  depends_on "python@3.13"

  resource "cloudpickle" do
    url "https://files.pythonhosted.org/packages/52/39/069100b84d7418bc358d81669d5748efb14b9cceacd2f9c75f550424132f/cloudpickle-3.1.1.tar.gz"
    sha256 "b216fa8ae4019d5482a8ac3c95d8f6346115d8835911fd4aefd1a445e4242c64"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doit --version")

    (testpath/"dodo.py").write <<~PYTHON
      def task_hello():
          """say hello"""
          def run_hello(targets):
              print("Hello World!")
              with open(targets[0], "w") as output:
                  output.write("hello")
              return True

          return {
              'actions': [run_hello],
              'targets': ["hello.txt"],
              'verbosity': 2,
          }
    PYTHON

    list_output = shell_output("#{bin}/doit list")
    assert_match "hello", list_output

    assert_match "Hello World!", shell_output("#{bin}/doit")
    assert_equal "hello", (testpath/"hello.txt").read
  end
end
