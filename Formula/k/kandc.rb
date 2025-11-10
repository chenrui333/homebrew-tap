class Kandc < Formula
  include Language::Python::Virtualenv

  desc "Accelerate your Python functions with cloud GPUs"
  homepage "https://github.com/Herdora/chisel"
  url "https://files.pythonhosted.org/packages/ee/3c/cc1a24bfef5f1d36e3fb1deefc3c91ca67802bfe0ae0dec531061e65698e/kandc-0.0.28.tar.gz"
  sha256 "e8b7246ab26ff5ccda0e6a0de054d3cad4088970bc4415635ef850dc4af80228"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9828ade2abb8deffb710a2a485ed90829f297fd16f2cc58746395e5719fd815c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.13"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/kandc config")
    assert_match "Keys & Caches Configuration:", output
  end
end
