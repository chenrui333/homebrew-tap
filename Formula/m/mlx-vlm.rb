class MlxVlm < Formula
  include Language::Python::Virtualenv

  desc "Run vision language models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-vlm"
  url "https://files.pythonhosted.org/packages/94/ec/108aec30efb159940ea29d133d5d8ec14840edbec914869b46eaafac5552/mlx_vlm-0.4.4.tar.gz"
  sha256 "3197e277c1be9ed1712ea04624df029e486f7747ad93e40e7bd1c9c771f8b179"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-vlm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "819fea8fe5ca7c6d6c0e19f08feef4ea7a725fe5bf030d7eb5c4e211040aa281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c95b6892fbef42d7e9b9a24102af5c113e8e161338b3502a7c348241589f382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbbc78c0ab00fe8cf7e6eee7cef80347157e4b2b4f8758cfee39bc05ee4741b5"
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

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/f7/e6/7adb4c5fa231e82c35b8f5741a9f2d055f520c29af5546fd70d3e8e1cd2e/fastapi-0.135.3.tar.gz"
    sha256 "bd6d7caf1a2bdd8d676843cdcd2287729572a1ef524fc4d65c17ae002a1be654"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/55/fa/96d4cc7ada283357117f7890418ac065a0a6d81ec59e681cd965a403aba3/miniaudio-1.61.tar.gz"
    sha256 "e88e97837d031f0fb6982394218b6487de02eaa382ad273b8fca37791a2b4b15"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/81/69/17425771797c36cded50b7fe44e850315d039f28b15901ab44839e70b593/starlette-1.0.0.tar.gz"
    sha256 "6a4beaf1f81bb472fd19ea9b918b50dc3a77a6f2e190a12954b25e6ed5eea149"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/62/f2/368268300fb8af33743508d738ef7bb4d56afdb46c6d9c0fa3dd515df171/uvicorn-0.43.0.tar.gz"
    sha256 "ab1652d2fb23abf124f36ccc399828558880def222c3cb3d98d24021520dc6e8"
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
