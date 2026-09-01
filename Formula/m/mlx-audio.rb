class MlxAudio < Formula
  include Language::Python::Virtualenv

  desc "Run audio models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-audio"
  url "https://files.pythonhosted.org/packages/e4/6b/117ed0a7e8375d615fbcc7cb96b54a1cf8dbadb3954e8a392ca082a8509f/mlx_audio-0.5.1.tar.gz"
  sha256 "67d11c213504306477a59290a1b2b5185cc0c85cbb2730ed84e9ee170864c98a"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-audio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "ef44fe1c4ca1cf2f6aaa5258e239b4a8915270f341f37aa25f963a09be2a7438"
    sha256 cellar: :any, arm64_sequoia: "9b78ec85da35940bd2de7ad2865c6e4b9ca7614ea4699535fa787f3a18020529"
    sha256 cellar: :any, arm64_sonoma:  "36635ddd9d3d7509dcee9d80a81cb4f2b7f60028d0fd64f40bc9ad280594bb40"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "gcc" # for gfortran
  depends_on "libomp"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on "llvm@20"
  depends_on :macos
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "python@3.14"
  depends_on "scipy" => :no_linkage

  on_macos do
    depends_on macos: :sonoma
  end

  pypi_packages exclude_packages: %w[
    certifi
    fastapi
    mlx
    mlx-lm
    numpy
    protobuf
    scipy
    uvicorn
  ]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/a0/50c2c0ce5e74d7721bbb1b19a26ebd339aac5878553a6e35308c2f31f935/filelock-3.32.5.tar.gz"
    sha256 "f6a6a28f743f9b95ce19db5abe0f376f75eb56517dff21e1a4751e2657d3e83d"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/00/78/f34251dadb8f3921264a1d9b8946f5e542014ee2614b285261b4e40e6775/fsspec-2026.7.0.tar.gz"
    sha256 "c803c40f4cf860b49dea58ee3e1c33cb9c790520e233537e1340049f89b82a88"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/64/35/42316e8f6908b6d21bc8df017cc6efba94fb5edbf99b64e28dd142325e20/huggingface_hub-1.29.0.tar.gz"
    sha256 "6ebb385a581435325cf6d5c5b233d5d4bc91175834d99fd65dae14379b36e9ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/d8/d5/e5439dc08561f73656bfeb3340fc64ab63163e101426593d8fb9a025ff1e/miniaudio-1.71.tar.gz"
    sha256 "ff51e2887bb673e2e757752b586b3dc924d59aa5fbcae9bbc45f4a111bd3262b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/61/d8/9c23ec31d4973d7b41a99f45c7aa9aa65c7c4313d5c0463aafdb8fe05dd7/regex-2026.8.31.tar.gz"
    sha256 "9350fd448a6442ae27853ab9d4b8d5a0bcb6d7774923a4fdfddd104c4458b35f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/45/06/f955dbbb1859e3bd23c8ac6141af5106e7ad5fedec4a3a6e3d60f94b7001/safetensors-0.8.0.tar.gz"
    sha256 "fabaf3e0f18a6618d9b36560682562157f77c2b71fcffc7b432be2baed9d753d"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/ec/db/0c890e2d9aab9ba284021efc02e1d3aebfecab1b611762d7434602209bcf/sounddevice-0.5.6.tar.gz"
    sha256 "8ec9fbfde2e32f020b167e348f3ab3bac6625a5f15af524d790108ac7147a410"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c1/60/21f715d9faba5f5407ff759472ade058ec4a507ad62bcea47cb847239a73/tokenizers-0.23.1.tar.gz"
    sha256 "1feeeadf865a7915adc25445dea30e9933e593c31bb96c277cee36de227c8bfa"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/ad/2e/ba418680ab901dae269360bb8642485eae04f1af91ee2ebb8bd6f3607305/transformers-5.16.1.tar.gz"
    sha256 "17b0eac726ddc55e84ac58946063e0c6d37fd000c456b581f050ea0f4e822869"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    ENV["LLVMLITE_SHARED"] = "1"
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup"

    # Work around upstream circular import: https://github.com/Blaizzy/mlx-audio/issues/828
    inreplace "mlx_audio/stt/models/__init__.py", /\A.*\z/m, ""

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources.reject { |r| r.name == "hf-xet" }
    resource("hf-xet").stage do
      ENV.O0
      venv.pip_install Pathname.pwd
    end
    venv.pip_install_and_link buildpath

    mlx_lm_site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("mlx-lm")/mlx_lm_site_packages}')\n"
    (venv.site_packages/"homebrew-mlx-lm.pth").write pth_contents

    unsupported_bins = [
      bin/"mlx_audio.server",
      libexec/"bin/mlx_audio.server",
      bin/"mlx_audio.sts.generate",
      libexec/"bin/mlx_audio.sts.generate",
      bin/"mlx_audio.tts.generate",
      libexec/"bin/mlx_audio.tts.generate",
    ].select(&:exist?)
    rm unsupported_bins unless unsupported_bins.empty?
  end

  test do
    output = shell_output("#{bin}/mlx_audio.convert 2>&1", 2)
    assert_match "the following arguments are required: --hf-path", output

    (testpath/"test.py").write <<~PYTHON
      from importlib.metadata import version
      from mlx_audio.stt.generate import format_timestamp, format_vtt_timestamp

      assert version("mlx-audio") == "#{version}"
      assert format_timestamp(61.234) == "00:01:01,234"
      assert format_vtt_timestamp(61.234) == "00:01:01.234"
    PYTHON

    system libexec/"bin/python", "test.py"
  end
end
