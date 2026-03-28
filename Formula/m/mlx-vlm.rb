class MlxVlm < Formula
  include Language::Python::Virtualenv

  desc "Run vision language models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-vlm"
  url "https://files.pythonhosted.org/packages/d1/92/ecd9747a9a4cfe36332d58a563881530bc676d97618b5d906ffcb914c8db/mlx_vlm-0.4.2.tar.gz"
  sha256 "31c84b4321c8f17cecb0457fa18d5c0689820a66af191926d240e7df9756453e"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-vlm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "156d2fe58023f33b097ceba9ed693d3bea78b7c8ae13fa5f88780d0032679d68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4aab73ddda30cf44fd39b3b508c445290167d32a7a8e7cdce936e23c717524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249eb666805e48511870c05d4e5f6d24f4a1938483dc2128b29c40f6af08d71b"
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

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/c4/73/5903c4b13beae98618d64eb9870c3fac4f605523dd0312ca5c80dadbd5b9/fastapi-0.135.2.tar.gz"
    sha256 "88a832095359755527b7f63bb4c6bc9edb8329a026189eed83d6c1afcf419d56"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/55/fa/96d4cc7ada283357117f7890418ac065a0a6d81ec59e681cd965a403aba3/miniaudio-1.61.tar.gz"
    sha256 "e88e97837d031f0fb6982394218b6487de02eaa382ad273b8fca37791a2b4b15"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/81/69/17425771797c36cded50b7fe44e850315d039f28b15901ab44839e70b593/starlette-1.0.0.tar.gz"
    sha256 "6a4beaf1f81bb472fd19ea9b918b50dc3a77a6f2e190a12954b25e6ed5eea149"
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
