class Pdfsyntax < Formula
  include Language::Python::Virtualenv

  desc "Python library & tool to inspect and modify PDF internals"
  homepage "https://pdfsyntax.dev/"
  url "https://files.pythonhosted.org/packages/67/5e/ab7a10970258b28f569de8981b4ca511936ece713b6b3f495d51e34c76ef/pdfsyntax-0.1.6.tar.gz"
  sha256 "b4d8823a83e77c4617bbcc96caabd1157e1ab8ae73c4af085c4397fb9a29f320"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "283f8b572ce14b3b6547501c531d2a336835cf0a295daae53e1d323fbfc25fed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6092ef77c09f4c1740fb18a314c2eed8c4c88dce4a77c47f7a8c4eed7573d873"
    sha256 cellar: :any_skip_relocation, ventura:       "abfcc25a9c88b73173c2b9ce0630fde6591d40889d5c1596701e168a153e7c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04e28e8048500ad23b10b7e10c2761195785c546454d442c0981a9cb8cc20f2f"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
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
