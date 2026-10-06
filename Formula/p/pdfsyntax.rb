class Pdfsyntax < Formula
  include Language::Python::Virtualenv

  desc "Python library & tool to inspect and modify PDF internals"
  homepage "https://pdfsyntax.dev/"
  url "https://files.pythonhosted.org/packages/67/5e/ab7a10970258b28f569de8981b4ca511936ece713b6b3f495d51e34c76ef/pdfsyntax-0.1.6.tar.gz"
  sha256 "b4d8823a83e77c4617bbcc96caabd1157e1ab8ae73c4af085c4397fb9a29f320"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "766a535e7ddcf86eb450127ce86fc8dc1aa834e7bb9ec6a2e5eab0476890a10c"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.13"

  deny_network_access!

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    test_pdf = test_fixtures("test.pdf")
    assert_match <<~EOS, shell_output("#{bin}/pdfsyntax overview #{test_pdf}")
      # Structure
      Version: 1.6
      Pages: 1
      Revisions: 1
      Encrypted: False
      Hybrid: False
      Linearized: False
      Paper of 1st page: 176x282mm or 6.94x11.11in (unknown)

      # Metadata
      Title: None
      Author: None
      Subject: None
      Keywords: None
      Creator: None
      Producer: None
      CreationDate: None
      ModDate: None
    EOS
  end
end
