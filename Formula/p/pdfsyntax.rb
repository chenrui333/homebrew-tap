class Pdfsyntax < Formula
  include Language::Python::Virtualenv

  desc "Python library & tool to inspect and modify PDF internals"
  homepage "https://pdfsyntax.dev/"
  url "https://files.pythonhosted.org/packages/44/a4/4c3018a22a9bf3ecd881b9abee9fd09db477715967f670d6d870eb87cbdc/pdfsyntax-0.1.5.tar.gz"
  sha256 "4d4c8654e909a4931e8033e8e03fbd831f97548dea021a000f80b611ef1f75ea"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539cb4936cc22216f009958e08886c92157a530e8abf893a72bd8cf9b6990ed3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7cbe71863653fbad6825fb5c99eb97d9d250adfb000e69f239eace5191e912e"
    sha256 cellar: :any_skip_relocation, ventura:       "cd9893f870df06af26661c7359c55b24062545ee151fd0311ce6e6221877b1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd8aa6f16a776ead9c8b4b4f62d57aaf08af1de4fb31d8b2925b7657a3e2f6b"
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
