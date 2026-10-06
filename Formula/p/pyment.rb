class Pyment < Formula
  include Language::Python::Virtualenv

  desc "Format and convert Python docstrings and generates patches"
  homepage "https://github.com/dadadel/pyment"
  url "https://files.pythonhosted.org/packages/dd/9e/c58a151c7020f6fdd48eea0085a9d1c91a57da19fa4e7bff0daf930c9900/Pyment-0.3.3.tar.gz"
  sha256 "951a4c52d6791ccec55bc739811169eed69917d3874f5fe722866623a697f39d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "da50f7e2933db71f2313369ee79d1dc96c053c93e4ee45d51d1fd6d0edd14b06"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.13"

  deny_network_access!

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyment --version")

    (testpath/"test.py").write <<~PYTHON
      def foo():
          print("Hello, World!")
    PYTHON

    system bin/"pyment", "-o", "google", "-w", "test.py"
    expected_output = <<~PYTHON
      def foo():
          """ """
          print("Hello, World!")
    PYTHON

    assert_equal expected_output, (testpath/"test.py").read
  end
end
