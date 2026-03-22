class MlxVlm < Formula
  include Language::Python::Virtualenv

  desc "Run vision language models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-vlm"
  url "https://files.pythonhosted.org/packages/57/8f/31204f1a8c7404e523a5578949ea668e668e10dd67a0f63336f261014c0f/mlx_vlm-0.4.1.tar.gz"
  sha256 "4e2d8a232715dbca72d346f43cf54d5738452848855792ffb1b285228ae7c7bd"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-vlm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f3a752e40adbda13009db9b7702c9d2bda634aa628d0fb86910d7608a07c38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f296336fa3b79923b0183f0e4ebe12742868198e23fe8e6a7bf38b02ed6958ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3f580a238b321073dea20727eaeeb352a2ce7e797db6308a314a35f54db0ff"
  end

  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "libsndfile"
  depends_on macos: :sonoma
  depends_on :macos
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "opencv"
  depends_on "pillow"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[
    certifi
    datasets
    mlx
    mlx-lm
    numpy
    opencv-python
    pillow
    pydantic
  ]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/e7/7b/f8e0211e9380f7195ba3f3d40c292594fd81ba8ec4629e3854c353aaca45/fastapi-0.135.1.tar.gz"
    sha256 "d04115b508d936d254cea545b7312ecaa58a7b3a0f84952535b4c9afae7668cd"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/e1/41/9b873a8c055582859b239be17902a85339bec6a30ad162f98c9b0288a2cc/soundfile-0.13.1.tar.gz"
    sha256 "b2c68dab1e30297317080a5b43df57e302584c49e2942defdde0acccc53f0e5b"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/c4/68/79977123bb7be889ad680d79a40f339082c1978b5cfcf62c2d8d196873ac/starlette-0.52.1.tar.gz"
    sha256 "834edd1b0a23167694292e94f597773bc3f89f362be6effee198165a35d62933"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/e3/ad/4a96c425be6fb67e0621e62d86c402b4a17ab2be7f7c055d9bd2f638b9e2/uvicorn-0.42.0.tar.gz"
    sha256 "9b1f190ce15a2dd22e7758651d9b6d12df09a13d51ba5bf4fc33c383a48e1775"
  end

  def install
    venv = virtualenv_install_with_resources

    mlx_lm_site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["mlx-lm"].opt_libexec/mlx_lm_site_packages}')\n"
    (venv.site_packages/"homebrew-mlx-lm.pth").write pth_contents

    unsupported_bins = [bin/"mlx_vlm.chat_ui", libexec/"bin/mlx_vlm.chat_ui"].select(&:exist?)
    rm unsupported_bins unless unsupported_bins.empty?
  end

  test do
    assert_match "Generate text from an image using a model",
                 shell_output("#{bin}/mlx_vlm.generate --help")
    assert_match "MLX VLM Http Server.",
                 shell_output("#{bin}/mlx_vlm.server --help")

    (testpath/"test.py").write <<~PYTHON
      import importlib.util
      import pathlib
      from importlib.metadata import version

      module_path = pathlib.Path("#{libexec}") / "lib/python3.14/site-packages/mlx_vlm/prompt_utils.py"
      spec = importlib.util.spec_from_file_location("mlx_vlm_prompt_utils", module_path)
      prompt_utils = importlib.util.module_from_spec(spec)
      spec.loader.exec_module(prompt_utils)

      assert version("mlx-vlm") == "0.4.1"
      content = [
        {"type": "text", "text": "Describe this image"},
        {"type": "image_url", "image_url": {"url": "https://example.com/image.png"}},
      ]
      assert prompt_utils.extract_text_from_content(content) == "Describe this image"
    PYTHON

    system libexec/"bin/python", "test.py"
  end
end
