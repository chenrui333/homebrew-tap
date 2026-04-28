class FortranLinter < Formula
  include Language::Python::Virtualenv

  desc "Fortran syntax checker"
  homepage "https://github.com/cphyc/fortran-linter"
  url "https://files.pythonhosted.org/packages/44/70/6377bd3337e2cd9984b648c076772958e59e99be2b0ada10b1953f4cf418/fortran_linter-1.1.3.tar.gz"
  sha256 "a5337e19ec13243011760dda6ed4c3c41eb9b9ad2983cf34179b4829c23ed5f2"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acaa22ac7d2eb0aef1d13110279e250ebec62fdca5554f6991ebefed59296570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b94239b0a42189413680b6bb7c18ae3c7dbf61e2a4f23dc0fac28d3c232b797"
    sha256 cellar: :any_skip_relocation, ventura:       "80fe0288be18511de43e9cefbe4a136f991cc0c63d1cf9480d6962cd4aa97e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2de8e05a0980c9d7095bbb9fa48632093b9daf796a7162481bf2940ad5c27a9"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    assert_empty shell_output("#{bin}/fortran-linter #{testpath}/test.f90 --syntax-only 2>&1").chomp
  end
end
