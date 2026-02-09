class Doit < Formula
  include Language::Python::Virtualenv

  desc "CLI task management & automation tool"
  homepage "https://pydoit.org/"
  url "https://files.pythonhosted.org/packages/35/f6/3a817d438799bda4d4e5fd136175cf7c328c074fadc1422dec3b374907e7/doit-0.37.0.tar.gz"
  sha256 "d3c72e0e46a8fa1ddabea8f830762402dee090caf33c30c2295ac7010db8f09c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "eeb1cfde14737d184cad2ef8cb262940d452ca9ff62a8700da52f6031400d3e0"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doit --version")

    (testpath/"dodo.py").write <<~PYTHON
      def task_hello():
          """say hello"""
          def run_hello(targets):
              print("Hello World!")
              with open(targets[0], "w") as output:
                  output.write("hello")
              return True

          return {
              'actions': [run_hello],
              'targets': ["hello.txt"],
              'verbosity': 2,
          }
    PYTHON

    list_output = shell_output("#{bin}/doit list")
    assert_match "hello", list_output

    assert_match "Hello World!", shell_output("#{bin}/doit")
    assert_equal "hello", (testpath/"hello.txt").read
  end
end
