class Refurb < Formula
  include Language::Python::Virtualenv

  desc "Tool for refurbishing and modernizing Python codebases"
  homepage "https://github.com/dosisod/refurb"
  url "https://files.pythonhosted.org/packages/1d/fe/34715ea7799daedfd8ef20fd8fbba23aa2aaa2039a94b41e63ee203e202d/refurb-2.1.0.tar.gz"
  sha256 "4fb41a3a6523a035c2379792776d4c28ddb291c7fcb8348725cc01749a98e32c"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957642dd6f18829f3d27a4a9a5e23e040280504f45c3fb2fe1f1f3c266287b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cc144b7163e86edc9e7d98b4a08ae9745e647dab83e4b89669abfdc682d69c"
    sha256 cellar: :any_skip_relocation, ventura:       "12199863f2a2ed9bdad6c65b15aa4b317b727196dbcdb6cec05c115c7d542930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34828098bb93b3a2c55b3b7c098569f6f256906e930ac834c0b10d86d2ea4f5"
  end

  depends_on "python@3.13"

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/ce/43/d5e49a86afa64bd3839ea0d5b9c7103487007d728e1293f52525d6d5486a/mypy-1.15.0.tar.gz"
    sha256 "404534629d51d3efea5c800ee7c42b72a6554d6c400e6a79eafe15d11341fd43"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/refurb --version")

    # Create a simple Python file to test
    (testpath/"test.py").write <<~EOS
      nums = [[]]

      if len(nums[0]):
          print("nums[0] is not empty")

      print("Hello, world!")
    EOS

    # Run refurb on the test file and check the output
    output = shell_output("#{bin}/refurb test.py 2>&1", 1)
    assert_match "[FURB115]: Replace `len(nums[0])` with `nums[0]`", output
  end
end
