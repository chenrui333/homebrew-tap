class Refurb < Formula
  include Language::Python::Virtualenv

  desc "Tool for refurbishing and modernizing Python codebases"
  homepage "https://github.com/dosisod/refurb"
  url "https://files.pythonhosted.org/packages/b1/9e/6f6d7d2d717edef96bb18ca62a08977640fa31f6803fbd61b13aaf6f70c8/refurb-2.3.0.tar.gz"
  sha256 "c6225698b7334760511038d8d5db75bc1524cc842e668fff27cda85fae29bef5"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7acb47d3bef5ae843b402e6af6a4746660f41f990ffb59df10941837ad7b1b9e"
  end

  depends_on "python@3.14"

  resource "librt" do
    url "https://files.pythonhosted.org/packages/56/9c/b4b0c54d84da4a94b37bd44151e46d5e583c9534c7e02250b961b1b6d8a8/librt-0.8.1.tar.gz"
    sha256 "be46a14693955b3bd96014ccbdb8339ee8c9346fbe11c1b78901b55125f14c73"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/f5/db/4efed9504bc01309ab9c2da7e352cc223569f05478012b5d9ece38fd44d2/mypy-1.19.1.tar.gz"
    sha256 "19d88bb05303fe63f71dd2c6270daca27cb9401c4ca8255fe50d1d920e0eb9ba"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
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
