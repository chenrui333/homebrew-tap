class FortranLinter < Formula
  include Language::Python::Virtualenv

  desc "Fortran syntax checker"
  homepage "https://github.com/cphyc/fortran-linter"
  url "https://files.pythonhosted.org/packages/44/70/6377bd3337e2cd9984b648c076772958e59e99be2b0ada10b1953f4cf418/fortran_linter-1.1.3.tar.gz"
  sha256 "a5337e19ec13243011760dda6ed4c3c41eb9b9ad2983cf34179b4829c23ed5f2"
  license "GPL-2.0-or-later"

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
