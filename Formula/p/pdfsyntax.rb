class Pdfsyntax < Formula
  include Language::Python::Virtualenv

  desc "Python library & tool to inspect and modify PDF internals"
  homepage "https://pdfsyntax.dev/"
  url "https://files.pythonhosted.org/packages/9d/69/cffe73e00c3e9548f8b5c61429a423857fa05f92b0f44ffeb2bfc85dd0cb/pdfsyntax-0.1.4.tar.gz"
  sha256 "6969b60ba1214325b35d2a176310078b13ac01aed81643d1160f6fa93e19a114"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e8d697324cd44bb0fdcf82759a744b132953daf5d070719f03fc85af250f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e37665ecb685c3909891a7417c4de4a46a438831c202614bb1823628bef54cc8"
    sha256 cellar: :any_skip_relocation, ventura:       "c42ef578ea1b199fc194b0720705b1063aa704da2c000dfbb4ccc06a4d25cef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef994d9d05416bc5016ecadfc00abf56ffee7ff4e11cfcb667389551435766e0"
  end

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
