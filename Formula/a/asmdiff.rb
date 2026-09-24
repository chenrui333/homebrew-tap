class Asmdiff < Formula
  include Language::Python::Virtualenv

  desc "Compare per-function assembly across compilers"
  homepage "https://github.com/rt-rtos/asmdiff"
  url "https://files.pythonhosted.org/packages/79/93/b634871bebc2db8f2fc59baf04a78356b13dab510fe8fe5c9a8aff3e0a49/asmdiff-0.4.0.tar.gz"
  sha256 "147454fd2367fe1a827a15d3987bd56f17f897a48a3ad66e2b6108e9e32ccd85"
  license "MIT"
  head "https://github.com/rt-rtos/asmdiff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0e49185dfe7e535e3c0c77de8be77add2ff9a00bbc3a43d8f84d9283e0a93e7c"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asmdiff --version")
    (testpath/"test.c").write "int add(int x) { return x + 1; }\n"
    output = shell_output("#{bin}/asmdiff test.c --cc '#{ENV.cc} -O2' --filter 'add$' --json")
    assert_match(/"_?add"/, output)
  end
end
