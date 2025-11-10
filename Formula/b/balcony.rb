class Balcony < Formula
  include Language::Python::Virtualenv

  desc "Read any AWS resource and generate Terraform code"
  homepage "https://oguzhan-yilmaz.github.io/balcony/"
  url "https://files.pythonhosted.org/packages/d6/8b/44beeca86fdd5bfed46e85e0108d454e448cd8c44084af36ce878f80e1ec/balcony-0.3.3.tar.gz"
  sha256 "ffb393afd91f0976d806fcbcbe41cb9e34cb69409242ff6a0b86c8bd1acf5c87"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "95222e654bfaa0db8d8e6ca4eaebb4e652f35e0dcc9c9ff8cc66ff966051d707"
    sha256 cellar: :any,                 arm64_sonoma:  "d1c7c00f7be41c1aed073a7421d5f9058c470c96938b90cb3441723502c231ac"
    sha256 cellar: :any,                 ventura:       "2a0a713b8c8385fe4c0bba4cd2ce45593f68e3f25d62c9463aa788a74689cab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea880b742e0d93e2dad0ebc8d322499a205ca18c82c3ba71108370c0b0c7e652"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.13" # Pydantic v1 is incompatible with Python 3.14

  pypi_packages exclude_packages: "certifi"

  resource "aws-jmespath-utils" do
    url "https://files.pythonhosted.org/packages/03/7d/dfbd180e7e6dac0a73ed5418175cfb60381b0b7f2bf55f6a0bd80fc005e1/aws_jmespath_utils-1.1.0.tar.gz"
    sha256 "c00177824763b6fdc40260a1926102da9cb40ced1142f9398ef62a65679a618e"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/6b/d52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240/babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "backrefs" do
    url "https://files.pythonhosted.org/packages/eb/a7/312f673df6a79003279e1f55619abbe7daebbb87c17c976ddc0345c04c7b/backrefs-5.9.tar.gz"
    sha256 "808548cb708d66b82ee231f962cb36faaf4f2baab032f2fbb783e9c2fdddaa59"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/56/36/65d292d14261aedbb9a22e5bf194d84c119c889135b42448db646d06d76b/boto3-1.40.69.tar.gz"
    sha256 "5273f6bac347331a87db809dff97d8736c50c3be19f2bb36ad08c5131c408976"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e2/73/42499b183ca5cef25c35338ad2636368b0ae2193654642756492e96ee906/botocore-1.40.69.tar.gz"
    sha256 "df310ddc4d2de5543ba3df4e4b5f9907a2951896d63a9fbae115c26ca0976951"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/d9/29/d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4/ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "griffe" do
    url "https://files.pythonhosted.org/packages/ec/d7/6c09dd7ce4c7837e4cdb11dce980cb45ae3cd87677298dc3b781b6bce7d3/griffe-1.14.0.tar.gz"
    sha256 "9d2a15c1eca966d68e00517de5d69dd1bc5c9f2335ef6c1775362ba5b8651a13"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "inflect" do
    url "https://files.pythonhosted.org/packages/76/2e/a7c1fd746c09d5d0498d6d00fa14afebdf26d44c3e64a630616489ece1a3/inflect-6.2.0.tar.gz"
    sha256 "518088ef414a4e15df70e6bcb40d021da4d423cc6c2fd4c0cad5500d39f86627"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/7d/ab/7dd27d9d863b3376fcf23a5a13cb5d024aed1db46f963f1b5735ae43b3be/markdown-3.10.tar.gz"
    sha256 "37062d4f2aa4b2b6b32aefb80faa300f82cc790cb949a35b8caede34f2b68c0e"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "mkdocs" do
    url "https://files.pythonhosted.org/packages/bc/c6/bbd4f061bd16b378247f12953ffcb04786a618ce5e904b8c5a01a0309061/mkdocs-1.6.1.tar.gz"
    sha256 "7b432f01d928c084353ab39c57282f29f92136665bdd6abf7c1ec8d822ef86f2"
  end

  resource "mkdocs-autorefs" do
    url "https://files.pythonhosted.org/packages/3b/3f/9531888bc92bafb1bffddca5d9240a7bae9a479d465528883b61808ef9d6/mkdocs-autorefs-0.4.1.tar.gz"
    sha256 "70748a7bd025f9ecd6d6feeba8ba63f8e891a1af55f48e366d6d6e78493aba84"
  end

  resource "mkdocs-get-deps" do
    url "https://files.pythonhosted.org/packages/98/f5/ed29cd50067784976f25ed0ed6fcd3c2ce9eb90650aa3b2796ddf7b6870b/mkdocs_get_deps-0.2.0.tar.gz"
    sha256 "162b3d129c7fad9b19abfdcb9c1458a651628e4b1dea628ac68790fb3061c60c"
  end

  resource "mkdocs-material" do
    url "https://files.pythonhosted.org/packages/57/de/cc1d5139c2782b1a49e1ed1845b3298ed6076b9ba1c740ad7c952d8ffcf9/mkdocs_material-9.6.23.tar.gz"
    sha256 "62ebc9cdbe90e1ae4f4e9b16a6aa5c69b93474c7b9e79ebc0b11b87f9f055e00"
  end

  resource "mkdocs-material-extensions" do
    url "https://files.pythonhosted.org/packages/79/9b/9b4c96d6593b2a541e1cb8b34899a6d021d208bb357042823d4d2cabdbe7/mkdocs_material_extensions-1.3.1.tar.gz"
    sha256 "10c9511cea88f568257f960358a467d12b970e1f7b2c0e5fb2bb48cab1928443"
  end

  resource "mkdocstrings" do
    url "https://files.pythonhosted.org/packages/d2/a1/d08d776e8fa2508b299fad8165374317dc742a58880398ed2f9a7ecddefc/mkdocstrings-0.21.2.tar.gz"
    sha256 "304e56a2e90595708a38a13a278e538a67ad82052dd5c8b71f77a604a4f3d911"
  end

  resource "mkdocstrings-python" do
    url "https://files.pythonhosted.org/packages/21/5e/1503ca2129b24e908eb075e87051e16ec583551423b8d305107e49a0bebb/mkdocstrings_python-1.8.0.tar.gz"
    sha256 "1488bddf50ee42c07d9a488dddc197f8e8999c2899687043ec5dd1643d057192"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paginate" do
    url "https://files.pythonhosted.org/packages/ec/46/68dde5b6bc00c1296ec6466ab27dddede6aec9af1b99090e1107091b3b84/paginate-0.5.7.tar.gz"
    sha256 "22bd083ab41e1a8b4f3690544afb2c60c25e5c9a63a30fa2f483f6c60c8e5945"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/ae/8d/7b346ed940c3e0f9eee7db9be37915a6dac0d9535d736e2ca47a81a066f3/pydantic-1.10.24.tar.gz"
    sha256 "7e6d1af1bd3d2312079f28c9baf2aafb4a452a06b50717526e5ac562e37baa53"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pymdown-extensions" do
    url "https://files.pythonhosted.org/packages/55/b3/6d2b3f149bc5413b0a29761c2c5832d8ce904a1d7f621e86616d96f505cc/pymdown_extensions-10.16.1.tar.gz"
    sha256 "aace82bcccba3efc03e25d584e6a22d27a8e17caa3f4dd9f207e49b787aa9a91"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "pyyaml-env-tag" do
    url "https://files.pythonhosted.org/packages/eb/2e/79c822141bfd05a853236b504869ebc6b70159afc570e1d5a20641782eaa/pyyaml_env_tag-1.1.tar.gz"
    sha256 "2eb38b75a2d21ee0475d6d97ec19c63287a7e140231e4214969d0eac923cd7ff"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e1/45/bcbc581f87c8d8f2a56b513eb994d07ea4546322818d95dc6a3caf2c928b/typer-0.7.0.tar.gz"
    sha256 "ff797846578a9f2a201b53442aedeb543319466870fbe1c701eab66dd7681165"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  patch :DATA

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"balcony", "--show-completion")
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"

    output = shell_output("#{bin}/balcony info")
    assert_match <<~EOS, output
      Current Profile:
          AWS Region: us-east-1
          AWS Profile: default
    EOS
  end
end

__END__
diff --git a/balcony/cli.py b/balcony/cli.py
index 1c42303..3dacc4a 100644
--- a/balcony/cli.py
+++ b/balcony/cli.py
@@ -41,7 +41,7 @@ console = get_rich_console()
 logger = get_logger(__name__)
 session = _create_boto_session()
 balcony_aws = BalconyAWS(session)
-app = typer.Typer(no_args_is_help=True, pretty_exceptions_enable=False)
+app = typer.Typer(no_args_is_help=True, pretty_exceptions_show_locals=False)



diff --git a/pyproject.toml b/pyproject.toml
index 811f0e1..1e20916 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -13,7 +13,7 @@ balcony                         = "balcony.cli:run_app"

 [tool.poetry.dependencies]
 python                          = "^3.9"
-typer                           = "^0.7.0"
+typer                           = "^0.12.0"
 rich                            = "^13.3.4"
 boto3                           = "^1.24.80"
 jmespath                        = "^1.0.1"
