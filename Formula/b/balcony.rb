class Balcony < Formula
  include Language::Python::Virtualenv

  desc "Read any AWS resource and generate Terraform code"
  homepage "https://oguzhan-yilmaz.github.io/balcony/"
  url "https://files.pythonhosted.org/packages/d6/8b/44beeca86fdd5bfed46e85e0108d454e448cd8c44084af36ce878f80e1ec/balcony-0.3.3.tar.gz"
  sha256 "ffb393afd91f0976d806fcbcbe41cb9e34cb69409242ff6a0b86c8bd1acf5c87"
  license "Apache-2.0"

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "aws-jmespath-utils" do
    url "https://files.pythonhosted.org/packages/03/7d/dfbd180e7e6dac0a73ed5418175cfb60381b0b7f2bf55f6a0bd80fc005e1/aws_jmespath_utils-1.1.0.tar.gz"
    sha256 "c00177824763b6fdc40260a1926102da9cb40ced1142f9398ef62a65679a618e"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/2a/74/f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9/babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/16/af/e41306c8fe705f19436b5339b23edcc6c4388b548c79fdd21cc120f61899/boto3-1.36.10.tar.gz"
    sha256 "d2f1010db699326b26fbd465d91c4b49177c9d995d7e72c0f31335f139efa0d2"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/da/8d21e15a1366a076c54529059c45c66943c217f1eadea5eb36791274d8d0/botocore-1.36.10.tar.gz"
    sha256 "d27bb73f0ea81395527a6298ac0a7ea5b2958094169f7cf7d48e3f4e4bc21b65"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/1c/ab/c9f1e32b7b1bf505bf26f0ef697775960db7932abeb7b516de930ba2705f/certifi-2025.1.31.tar.gz"
    sha256 "3d5da6925056f6f18f119200434a4780a94263f10d1c21d032a6f6b2baa20651"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/88/f0/a001e06c321dfa220103418259afbac50b933eac7a86657a4b572f0517e8/griffe-1.5.6.tar.gz"
    sha256 "181f6666d5aceb6cd6e2da5a2b646cfb431e47a0da1fda283845734b67e10944"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "inflect" do
    url "https://files.pythonhosted.org/packages/76/2e/a7c1fd746c09d5d0498d6d00fa14afebdf26d44c3e64a630616489ece1a3/inflect-6.2.0.tar.gz"
    sha256 "518088ef414a4e15df70e6bcb40d021da4d423cc6c2fd4c0cad5500d39f86627"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/11/28/c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606/Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
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
    url "https://files.pythonhosted.org/packages/c7/16/c48d5a28bc4a67c49808180b6009d4d1b4c0753739ffee3cc37046ab29d7/mkdocs_material-9.5.50.tar.gz"
    sha256 "ae5fe16f3d7c9ccd05bb6916a7da7420cf99a9ce5e33debd9d40403a090d5825"
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
    url "https://files.pythonhosted.org/packages/92/47/9d771f91359e5377cf19385a056aa4da43324995d72b1fac9d77c840d423/mkdocstrings_python-1.9.1.tar.gz"
    sha256 "077188fa43eab3b689826b15da7da6753501224b2482e4eca3ce4412ce3b71cb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/c3/e9/d99a2c4f8f6d7c711f39f6ecf485b7f3bba66189bbbad505d24eb0106922/pydantic-1.10.21.tar.gz"
    sha256 "64b48e2b609a6c22178a56c408ee1215a7206077ecb8a193e2fda31858b2362a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pymdown-extensions" do
    url "https://files.pythonhosted.org/packages/b0/ec/e3d966cfb286d5a48e7c43a559a297b857ab935209ee9072e5a5492706c9/pymdown_extensions-10.7.1.tar.gz"
    sha256 "c70e146bdd83c744ffc766b4671999796aba18842b268510a329f7f64700d584"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyyaml-env-tag" do
    url "https://files.pythonhosted.org/packages/fb/8e/da1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629c/pyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/45/2323b5928f86fd29f9afdcef4659f68fa73eaa5356912b774227f5cf46b5/s3transfer-0.11.2.tar.gz"
    sha256 "3b39185cb72f5acc77db1a58b6e25b977f28d20496b6e58d6813d75f464d632f"
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
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"balcony", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    ENV["AWS_DEFAULT_REGION"] = "us-west-2"

    output = shell_output("#{bin}/balcony info")
    assert_match <<~EOS, output
      Current Profile:
          AWS Region: us-west-2
          AWS Profile: default
    EOS
  end
end
