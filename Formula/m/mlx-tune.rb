class MlxTune < Formula
  include Language::Python::Virtualenv

  desc "Fine-tune LLMs on Apple Silicon with MLX"
  homepage "https://github.com/ARahim3/mlx-tune"
  url "https://files.pythonhosted.org/packages/d0/5a/01718660a6b8c3de4662809da9bac2c3baffddb4c04a140b0b4f6c2fe362/mlx_tune-0.4.3.tar.gz"
  sha256 "e2d23b9cb0a77b27fdf4a4da31b6b6718a69ffa2390e4ede8d29a6a4c65e483e"
  license "Apache-2.0"
  head "https://github.com/ARahim3/mlx-tune.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "2275b942167533187d939ec1a4517e200c8d527efde66d9e62c5fa48c0578085"
    sha256 cellar: :any, arm64_sequoia: "1bc28ce4e3d05945bbafabfb2388d245a9f072821636489e2900f467782f30f0"
    sha256 cellar: :any, arm64_sonoma:  "80ed53298cac0d2608880a192a368b0c35e190d790fb815a36f6531c4c655fc4"
  end

  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on macos: :sonoma
  depends_on :macos
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "datasets" do
    url "https://files.pythonhosted.org/packages/d7/02/741da3bed890bdf9720eb1b24780a58456bfdde49c4c78237953bb08abae/datasets-4.8.2.tar.gz"
    sha256 "c6ad7e6c28c7436a9c6c23f817d1a450d395c771df881252dfe63697297cbcdf"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "multiprocess" do
    url "https://files.pythonhosted.org/packages/a2/f2/e783ac7f2aeeed14e9e12801f22529cc7e6b7ab80928d6dcce4e9f00922d/multiprocess-0.70.19.tar.gz"
    sha256 "952021e0e6c55a4a9fe4cd787895b86e239a40e76802a789d6305398d3975897"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/72/3a/5b39b51c64159f470f1ca3b1c2a87da290657ca022f7cd11442606f607d1/pandas-3.0.1-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "3b66857e983208654294bb6477b8a63dee26b37bdd0eb34d010556e91261784f"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/8d/1b/6da9a89583ce7b23ac611f183ae4843cd3a6cf54f079549b0e8c14031e73/pyarrow-23.0.1-cp314-cp314-macosx_12_0_arm64.whl"
    sha256 "5df1161da23636a70838099d4aaa65142777185cc0cdba4037a18cee7d8db9ca"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/02/84/30869e01909fb37a6cc7e18688ee8bf1e42d57e7e0777636bd47524c43c7/xxhash-3.6.0.tar.gz"
    sha256 "f0162a78b13a0d7617b2845b90c763339d1f1d82bb04a4b07f4ab535cc5e05d6"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  def install
    wheel_resources = %w[pandas pyarrow]
    venv = virtualenv_create(libexec, "python3.14")

    venv.pip_install resources.reject { |resource| wheel_resources.include?(resource.name) }

    wheel_resources.each do |resource_name|
      wheel_resource = resource(resource_name)
      wheel_resource.stage do
        venv.pip_install Pathname.pwd/wheel_resource.downloader.basename
      end
    end

    venv.pip_install_and_link buildpath

    # `mlx-lm` installs its Python package into its own venv, so link that venv in explicitly.
    mlx_lm_site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["mlx-lm"].opt_libexec/mlx_lm_site_packages}')\n"
    (venv.site_packages/"homebrew-mlx-lm.pth").write pth_contents
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from datasets import Dataset
      from importlib.metadata import version
      from mlx_tune import apply_column_mapping, detect_dataset_format, get_template_for_model

      assert version("mlx-tune") == "0.4.3"

      dataset = Dataset.from_dict({"question": ["Hello"], "answer": ["World"]})
      mapped = apply_column_mapping(dataset, {"instruction": "question", "output": "answer"})

      assert mapped.column_names == ["instruction", "output"]
      assert mapped[0]["instruction"] == "Hello"
      assert mapped[0]["output"] == "World"
      assert detect_dataset_format(mapped[0]) == "alpaca"
      assert get_template_for_model("meta-llama/Llama-3.2-1B-Instruct") == "llama-3.1"
    PYTHON

    system libexec/"bin/python", "test.py"
  end
end
