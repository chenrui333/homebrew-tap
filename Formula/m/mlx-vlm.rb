class MlxVlm < Formula
  include Language::Python::Virtualenv

  desc "Run vision language models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-vlm"
  url "https://files.pythonhosted.org/packages/e2/28/814ea4dcc7239e04836edc86307d325387bb155e46de516ded762c42bac5/mlx_vlm-0.6.0.tar.gz"
  sha256 "bbd8883202b8d167dd1eb9caee3ac0872cdfbf3b6afcbe3ddfb6d76ee6035d8c"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-vlm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "5eb34cd26aa64f5c88f468b243ea724529d2ad00ffe450c9406c2db034e82f84"
    sha256 arm64_sequoia: "c214c72584ae0c4d35a0685820b9cb7d5cf82fe999bba7771e67bf1bfd03ba08"
    sha256 arm64_sonoma:  "378202cb0dbec1e225085dde0b3a98b449175b18a13f08f3cd952a9d7498a542"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "gcc"
  depends_on "libsndfile"
  depends_on macos: :sonoma
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "opencv"
  depends_on "pillow" => :no_linkage
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
    url "https://files.pythonhosted.org/packages/81/2d/ff8d91d7b564d464629a0fd50a4489c97fcb836ac230bf3a7269232a9b1f/fastapi-0.136.3.tar.gz"
    sha256 "e487fae93ad408e6f47641ee4dfe389864fd7bec92e547ea8498fc13f43e83ab"
  end

  resource "llguidance" do
    url "https://files.pythonhosted.org/packages/74/2a/e889d6fdddda852171cf537486513d59fd8d9c38104323c1851a73675f1f/llguidance-1.7.5.tar.gz"
    sha256 "afaa8f979708cd546c762f06a4fe4748e5ef7f06ed45875dabe7db8f07b73645"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/d8/d5/e5439dc08561f73656bfeb3340fc64ab63163e101426593d8fb9a025ff1e/miniaudio-1.71.tar.gz"
    sha256 "ff51e2887bb673e2e757752b586b3dc924d59aa5fbcae9bbc45f4a111bd3262b"
  end

  resource "mlx-audio" do
    url "https://files.pythonhosted.org/packages/95/db/a9f95e3794eca373d681220c8b9f8f84451a0d14959f85cc341ca592394c/mlx_audio-0.4.3.tar.gz"
    sha256 "8e87badf56a0f73bf91e3797b1195c01440a181cf0b64a2a08dc1bda4b037f54"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/7a/97/5a3609c4f8d58b039179648e62dd220f89864f56f7357f5d4f45c29eb2cc/scipy-1.17.1.tar.gz"
    sha256 "95d8e012d8cb8816c226aef832200b1d45109ed4464303e997c5b13122b297c0"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/2a/f9/2592608737553638fca98e21e54bfec40bf577bb98a61b2770c912aab25e/sounddevice-0.5.5.tar.gz"
    sha256 "22487b65198cb5bf2208755105b524f78ad173e5ab6b445bdab1c989f6698df3"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/25/44/ec35f1b6e83094b997da438a02c8c9b0ade2b1e84cfc48bd4656780760a6/starlette-1.2.1.tar.gz"
    sha256 "9b9b5ebb992e67d6093741e63c2f59e4f6fff986f81163c087867bd7b924b3f6"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/e6/bf/f6544ba992ddb9a6077343a576f9844f7f8f06ab819aefd00206e9255f18/uvicorn-0.48.0.tar.gz"
    sha256 "a5504207195d08c2511bf9125ede5ac4a4b71725d519e758d01dcf0bc2d31c37"
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

      assert version("mlx-vlm") == "#{version}"
      content = [
        {"type": "text", "text": "Describe this image"},
        {"type": "image_url", "image_url": {"url": "https://example.com/image.png"}},
      ]
      assert prompt_utils.extract_text_from_content(content) == "Describe this image"
    PYTHON

    system libexec/"bin/python", "test.py"
  end
end
