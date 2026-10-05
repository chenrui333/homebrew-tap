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

  pypi_packages extra_packages: %w[
    flit-core poetry-core setuptools types-psutil types-setuptools
  ]

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

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

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "types-psutil" do
    url "https://files.pythonhosted.org/packages/97/0a/f48b9b0ab5ba8599fd117309e345152bf82c756c72be2ff0f635780c2792/types_psutil-7.2.2.20260906.tar.gz"
    sha256 "93abf22cf9a62b915f724e433bde702995ac274865425fd4a76d1d9b5828da1a"
  end

  resource "types-setuptools" do
    url "https://files.pythonhosted.org/packages/4f/cd/3b2a3362a526f91c33f785a291462b2ec448ae531101c62372fc30a21f53/types_setuptools-84.0.0.20260812.tar.gz"
    sha256 "09bedc248ebbb7a232c9419dfcdca329706e61bf2aa5743e9424d027f1d956b4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  deny_network_access!

  def install
    build_resources = %w[
      flit-core
      mypy-extensions
      pathspec
      poetry-core
      setuptools
      librt
      types-psutil
      types-setuptools
      typing-extensions
    ]

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |r| build_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
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
