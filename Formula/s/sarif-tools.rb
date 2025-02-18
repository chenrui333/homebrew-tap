class SarifTools < Formula
  include Language::Python::Virtualenv

  desc "Set of command-line tools and Python library for working with SARIF files"
  homepage "https://github.com/microsoft/sarif-tools"
  url "https://files.pythonhosted.org/packages/bc/3a/196b2eb2537a27469a07b36c309eb1fa0509275af4fa03a6afdfb46efb9d/sarif_tools-3.0.4.tar.gz"
  sha256 "2be0a7624f9b155ab984c99dc6375e18877790adc70eb2d2f164c7e4e47e6c33"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "5e690d96f889344c255d84dd5edbf8c2bb680218f57a316f80145e43bd13ddb8"
    sha256 cellar: :any,                 arm64_sonoma:  "721709058155d2b06e3b1469d2470a563539abb5d31a8d3b3cc950ba63f2bed8"
    sha256 cellar: :any,                 ventura:       "3cff60849d309fe7f159e4054951885aa705944d69a39d19babe1dda0b5eff29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83afe3260a3e8b0aed90dfd8b83e5c8211f80a1003e39f292a4c0148d0590f8"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/25/c2/fc7193cc5383637ff390a712e88e4ded0452c9fbcf84abe3de5ea3df1866/contourpy-1.3.1.tar.gz"
    sha256 "dfd97abd83335045a913e3bcc4a09c0ceadbe66580cf573fe961f4a825efa699"
  end

  resource "cycler" do
    url "https://files.pythonhosted.org/packages/a9/95/a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8/cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/1c/8c/9ffa2a555af0e5e5d0e2ed7fdd8c9bef474ed676995bb4c57c9cd0014248/fonttools-4.56.0.tar.gz"
    sha256 "a114d1567e1a1586b7e9e7fc2ff686ca542a82769a296cef131e4c4af51e58f4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/6d/86/08646239a313f895186ff0a4573452038eed8c86f54380b3ebac34d32fb2/jsonpath-ng-1.7.0.tar.gz"
    sha256 "f6f5f7fd4e5ff79c785f1573b394043b39849fb2bb47bcead935d12b00beab3c"
  end

  resource "kiwisolver" do
    url "https://files.pythonhosted.org/packages/82/59/7c91426a8ac292e1cdd53a63b6d9439abd573c875c3f92c146767dd33faf/kiwisolver-1.4.8.tar.gz"
    sha256 "23d5f023bdc8c7e54eb65f03ca5d5bb25b601eac4d7f1a042888a1f45237987e"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/68/dd/fa2e1a45fce2d09f4aea3cee169760e672c8262325aa5796c49d543dc7e6/matplotlib-3.10.0.tar.gz"
    sha256 "b886d02a581b96704c9d1ffe55709e49b4d2d52709ccebc4be42db856e511278"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-docx" do
    url "https://files.pythonhosted.org/packages/35/e4/386c514c53684772885009c12b67a7edd526c15157778ac1b138bc75063e/python_docx-1.1.2.tar.gz"
    sha256 "0cf1f22e95b9002addca7948e16f2cd7acdfd498047f1941ca5d293db7762efd"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sarif --version")

    (testpath/"test.sarif").write <<~EOS
      {
        "$schema": "https://schemastore.azurewebsites.net/schemas/json/sarif-2.1.0-rtm.5.json",
        "version": "2.1.0",
        "runs": []
      }
    EOS

    output = shell_output("#{bin}/sarif summary test.sarif")
    assert_match "error: 0\n\nwarning: 0\n\nnote: 0", output
  end
end
