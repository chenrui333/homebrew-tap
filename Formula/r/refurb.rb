class Refurb < Formula
  include Language::Python::Virtualenv

  desc "Tool for refurbishing and modernizing Python codebases"
  homepage "https://github.com/dosisod/refurb"
  url "https://files.pythonhosted.org/packages/48/90/572837d7ec45cb9385b85b751bd5f317294a938e1600b2b7190618a2929b/refurb-2.3.1.tar.gz"
  sha256 "8605ef2cf40804403340396b9cf51b13bd5d0f5f6a84f8b4447484b7ba94bc79"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a06cdc0e330b94da5acbeef2cf9633359bd1a480118fb67adf61c5a08c0f29f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ff62e7912dd8ffe00218032c7391f2c41d069b84aca6574c1946593267a4f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26846944de616848e43b9ab61bbb5d3c61ee8224f4671b3aea5aa9eec0512e37"
    sha256 cellar: :any_skip_relocation, sequoia:       "25af157699af8e142617e8d46a7b730d08d99e0c37aa01edd016e16aef68acb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f39c20783dc41f6a3bceee65de1ca7e310b290aee33aa8469d2c19af1b454200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de502cdd823daee1144fe8950f525873476f279d8544ca023371220527c2e02"
  end

  depends_on "python@3.14"

  resource "librt" do
    url "https://files.pythonhosted.org/packages/56/9c/b4b0c54d84da4a94b37bd44151e46d5e583c9534c7e02250b961b1b6d8a8/librt-0.8.1.tar.gz"
    sha256 "be46a14693955b3bd96014ccbdb8339ee8c9346fbe11c1b78901b55125f14c73"
  end

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/f8/5c/b0089fe7fef0a994ae5ee07029ced0526082c6cfaaa4c10d40a10e33b097/mypy-1.20.0.tar.gz"
    sha256 "eb96c84efcc33f0b5e0e04beacf00129dd963b67226b01c00b9dfc8affb464c3"
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
