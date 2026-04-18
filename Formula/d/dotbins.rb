class Dotbins < Formula
  include Language::Python::Virtualenv

  desc "TUI typing trainer inspired by monkeytype with a focus on customization"
  homepage "https://github.com/basnijholt/dotbins"
  url "https://files.pythonhosted.org/packages/9e/9c/a83160159d3617d0882e802bf8965e7cf4242bfc2cf3677de5fd462942d9/dotbins-2.10.1.tar.gz"
  sha256 "c358792ff7c28f46310789e174431e5207d082124b7ce0c5b70514816e483e9b"
  license "Apache-2.0"
  head "https://github.com/basnijholt/dotbins.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cea5330450717ac35ee34a99cc6e038dfc8e5634e35bce6341c73cecf3938e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6110697d92edb0ff575f7892f32da93dae817e33bdb7678f3367b2573765bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec55d8f2101ae861cf87b08dc787a5182ccafb7ee101fea88fa121a1a2d6462"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbcb9b32927e44a7e5248f659733abbbd7a2be3daa1a4a95306df9c96c328bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ec42459d036bcf77f5e0044d8a5e228ab7c252026cc04d3720515b22319b538"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/4c/f7/1c65e0245d4c7009a87ac92908294a66e7e7635eccf76a68550f40c6df80/rich_argparse-1.7.2.tar.gz"
    sha256 "64fd2e948fc96e8a1a06e0e72c111c2ce7f3af74126d75c0f5f63926e7289cd1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotbins version")

    output = shell_output("#{bin}/dotbins list")
    assert_match "⚠️ No configuration file found, using default settings", output
  end
end
