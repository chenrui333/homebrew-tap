class AutotoolsLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language tools for Autotools, support configure.ac, Makefile.am, Makefile"
  homepage "https://github.com/Freed-Wu/autotools-language-server"
  url "https://files.pythonhosted.org/packages/6a/d8/a3b874f312ea727c5d2f71efb8c066199c731370a334d1eed1521e495aa6/autotools_language_server-0.0.22.tar.gz"
  sha256 "dea1dcfb6fc62a225371cd8e090953a368d12b23760037d6814d0dc48575afdf"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build # for rpds-py
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/64/65/af6d57da2cb32c076319b7489ae0958f746949d407109e3ccf4d115f147c/cattrs-24.1.2.tar.gz"
    sha256 "8028cfe1ff5382df59dd36474a86e02d817b06eaf8af84555441bac915d2ef85"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "lsp-tree-sitter" do
    url "https://files.pythonhosted.org/packages/e8/f7/7cee57b01c26878242c8cf1903e44b9a03ddf7e9e1ef61e09b33d300acb5/lsp_tree_sitter-0.0.17.tar.gz"
    sha256 "ba35219ee38a5c2e2d3e157c7e5dfd34a6edc351f47e5ee70bda9955b257c7fe"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/86/b9/41d173dad9eaa9db9c785a85671fc3d68961f08d67706dc2e79011e10b5c/pygls-1.3.1.tar.gz"
    sha256 "140edceefa0da0e9b3c533547c892a42a7d2fd9217ae848c330c53d266a55018"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/01/80/cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfd/rpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/a7/a2/698b9d31d08ad5558f8bfbfe3a0781bd4b1f284e89bde3ad18e05101a892/tree-sitter-0.24.0.tar.gz"
    sha256 "abd95af65ca2f4f7eca356343391ed669e764f37748b5352946f00f7fc78e734"
  end

  resource "tree-sitter-make" do
    url "https://files.pythonhosted.org/packages/b6/c9/4b534b0f8be76b5a7495419e7017998ceb1cd260ca91b4bf2358f00af97e/tree_sitter_make-1.1.1.tar.gz"
    sha256 "ef394673ab83956dffb3986526f4c059082ff2d84c87f9da18ab30030f561b4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    %w[autoconf-language-server autotools-language-server make-language-server].each do |f|
      assert_match version.to_s, shell_output("#{bin}/#{f} --version")
    end

    (testpath/"Makefile").write <<~EOF
      all:
      \t@echo "Hello, World!"
    EOF

    system bin/"make-language-server", "--check", testpath/"Makefile"
  end
end
