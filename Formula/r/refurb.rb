class Refurb < Formula
  include Language::Python::Virtualenv

  desc "Tool for refurbishing and modernizing Python codebases"
  homepage "https://github.com/dosisod/refurb"
  url "https://files.pythonhosted.org/packages/02/53/c90648f39d7b5d61122b7c6978cdfa29e8bdfd758711306d770c1a339b00/refurb-2.2.0.tar.gz"
  sha256 "645472793b3af40cca121e37df45dd9b20b525c4df99429d9fd9f6b5c238b9ea"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200f3d0ec3e960cb63ca206a7ce0c9b27d4f9cbe1d6377bdb8b3a8d04757a6ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68f5f58a14df1ca63a5dccb87b18b42a14e355c8f4857c802f89d43c0535cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54b07124f7707f282f7eeeab645c22de5bf1310fcc798451a11487a1a39a208d"
  end

  depends_on "python@3.13"

  resource "mypy" do
    url "https://files.pythonhosted.org/packages/14/a3/931e09fc02d7ba96da65266884da4e4a8806adcdb8a57faaacc6edf1d538/mypy-1.18.1.tar.gz"
    sha256 "9e988c64ad3ac5987f43f5154f884747faf62141b7f842e87465b45299eea5a9"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
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
