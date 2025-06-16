class Tclint < Formula
  include Language::Python::Virtualenv

  desc "EDA-centric utility for linting and analyzing Tcl code"
  homepage "https://github.com/nmoroze/tclint"
  url "https://files.pythonhosted.org/packages/46/2e/e0b87f58765f43937e06b3f7f5f3e299ec0479fcf99a7ef5c033614d5cdc/tclint-0.6.0.tar.gz"
  sha256 "8dd4d7b519e040c164615df8072cc4c28def4bfdc9d2a8672a280b0984b45fc3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ada7bcd300bafed08db5bc0f5ec698320be986ea3f60f832bec5bf6ada515c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98313f945415609e11a8ecaa07bb72fbd15e736ed86b58f1a50fe1b609084b1"
    sha256 cellar: :any_skip_relocation, ventura:       "4ca4392dc5d5f5ce07c23ab0b8759c7b47690297538b5ff0a09a7b4cc4b53ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c2df614e44a5a30a2684a725df469ee55dedec61d9ec70ccae437192aa5a37"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/57/2b/561d78f488dcc303da4639e02021311728fb7fda8006dd2835550cddd9ed/cattrs-25.1.1.tar.gz"
    sha256 "c914b734e0f2d59e5b720d145ee010f1fd9a13ee93900922a2f3f9d593b8382c"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/86/b9/41d173dad9eaa9db9c785a85671fc3d68961f08d67706dc2e79011e10b5c/pygls-1.3.1.tar.gz"
    sha256 "140edceefa0da0e9b3c533547c892a42a7d2fd9217ae848c330c53d266a55018"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/91/af/a54ce0fb6f1d867e0b9f0efe5f082a691f51ccf705188fca67a3ecefd7f4/voluptuous-0.15.2.tar.gz"
    sha256 "6ffcab32c4d3230b4d2af3a577c87e1908a714a11f6f95570456b1849b0279aa"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tclint --version")
    (testpath/"test.tcl").write <<~TCL
      #!/usr/bin/env tclsh
      puts "Hello, World!"
    TCL

    system bin/"tclint", "test.tcl"
  end
end
