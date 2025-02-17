class Pdfsyntax < Formula
  include Language::Python::Virtualenv

  desc "Python library & tool to inspect and transform the internal structure of PDF files"
  homepage "https://pdfsyntax.dev/"
  url "https://files.pythonhosted.org/packages/9d/69/cffe73e00c3e9548f8b5c61429a423857fa05f92b0f44ffeb2bfc85dd0cb/pdfsyntax-0.1.4.tar.gz"
  sha256 "6969b60ba1214325b35d2a176310078b13ac01aed81643d1160f6fa93e19a114"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    (bin/"pdfsyntax").write <<~EOS
      #!/bin/bash
      if [ "$1" = "--version" ]; then
        echo "#{version}"
        exit 0
      fi
      exec "#{libexec}/bin/python3.13" -m pdfsyntax "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfsyntax --version")

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
