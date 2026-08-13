class MlxVlm < Formula
  include Language::Python::Virtualenv

  desc "Run vision language models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-vlm"
  url "https://files.pythonhosted.org/packages/29/43/9426a1b1e2be786b901fa23e752fe9c9a8d4329c4a57fe79aaecb6aa6d35/mlx_vlm-0.6.13.tar.gz"
  sha256 "c9564d6f01df6cc72a47fb64fbc4c28918021849ee6451bc241cd78a4a5bd327"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-vlm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "11f85213be4afc216e0f1b328f5cb889f4c7c5a07ad9570a18b8f0dfacb7cb97"
    sha256 arm64_sequoia: "74447a7c041a3838a97bc4f1120b48e9d283c10adb3d2c8b197524e5bb8de609"
    sha256 arm64_sonoma:  "c8ded5444630b25e08b3971aa653900809d4dad9cd85f19872fa3993a6c8d2f3"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cb/31/4971872b3ed8715346231fb6eb4da8fcba65a4143c189db151ee28a2812b/charset_normalizer-3.5.0.tar.gz"
    sha256 "49bd5feb59b0bf3cbf6ebcf4352e371c95b9da9bacd4449f8b64d0ad2c10a26e"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/8a/02/91e3416a8fdd715abb903a952a6bec7cdd8d14eed55d415fc8595524c319/fastapi-0.141.1.tar.gz"
    sha256 "e8822fc40db1e1858054d7a949a888695bc9bdce70139178e33bd2871a453ca1"
  end

  resource "llguidance" do
    url "https://files.pythonhosted.org/packages/20/27/972de1ba4c93072fce816b967972e1d18bc48b04b145b5c77b5bd1dc9662/llguidance-1.8.0.tar.gz"
    sha256 "18d1579eabb040e65c870d50c6df19a7bef140c5260d12ad35b7f0dc446312e0"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/d8/d5/e5439dc08561f73656bfeb3340fc64ab63163e101426593d8fb9a025ff1e/miniaudio-1.71.tar.gz"
    sha256 "ff51e2887bb673e2e757752b586b3dc924d59aa5fbcae9bbc45f4a111bd3262b"
  end

  resource "mlx-audio" do
    url "https://files.pythonhosted.org/packages/16/e4/a936c9e2a94b0cf44aacd3e2513bc3ad9814f6faa0a585a841182115fd67/mlx_audio-0.4.8.tar.gz"
    sha256 "898b999a1deb1aeaa9dad06d62b0c5973e966586ee8d79b74474b9520c9f7b18"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/a7/25/c2700dfaf6442b4effaa91af24ebce5dc9d31bb4a69706313aae70d72cd0/scipy-1.18.0.tar.gz"
    sha256 "67b2ad2ad54c72ca6d04975a9b2df8c3638c34ddd5b28738e94fc2b57929d378"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/2a/f9/2592608737553638fca98e21e54bfec40bf577bb98a61b2770c912aab25e/sounddevice-0.5.5.tar.gz"
    sha256 "22487b65198cb5bf2208755105b524f78ad173e5ab6b445bdab1c989f6698df3"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b5/b4/205b0d5241d934e8add0c38aa924c4f9fb7330834ff11e5444db964ec3f9/starlette-1.6.0.tar.gz"
    sha256 "d4e3ac5e546444960c710297a3c9fc3f7ebae1b7e963f3d36173b49da535be9b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/03/18/ccce41535dee1be77735592bd19965f3972c82e07ee703d324709496b716/uvicorn-0.52.1.tar.gz"
    sha256 "112ec661814189acbccd3f7b86460147cc065fc92c0821afa78918780e4354dd"
  end

  def install
    venv = virtualenv_install_with_resources

    mlx_lm_site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("mlx-lm")/mlx_lm_site_packages}')\n"
    (venv.site_packages/"homebrew-mlx-lm.pth").write pth_contents

    unsupported_bins = [bin/"mlx_vlm.chat_ui", libexec/"bin/mlx_vlm.chat_ui"].select(&:exist?)
    rm unsupported_bins unless unsupported_bins.empty?
  end

  test do
    require "open3"

    output, status = Open3.capture2e(bin/"mlx_vlm.generate", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output

    (testpath/"test.py").write <<~PYTHON
      import importlib.util
      import pathlib
      from importlib.metadata import version
      import requests

      module_path = pathlib.Path("#{libexec}") / "lib/python3.14/site-packages/mlx_vlm/prompt_utils.py"
      spec = importlib.util.spec_from_file_location("mlx_vlm_prompt_utils", module_path)
      prompt_utils = importlib.util.module_from_spec(spec)
      spec.loader.exec_module(prompt_utils)

      assert version("mlx-vlm") == "#{version}"
      assert version("requests") == "2.34.2"
      content = [
        {"type": "text", "text": "Describe this image"},
        {"type": "image_url", "image_url": {"url": "https://example.com/image.png"}},
      ]
      assert prompt_utils.extract_text_from_content(content) == "Describe this image"
    PYTHON

    system libexec/"bin/python", "test.py"
  end
end
