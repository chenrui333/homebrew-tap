class MlxAudio < Formula
  include Language::Python::Virtualenv

  desc "Run audio models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-audio"
  url "https://files.pythonhosted.org/packages/95/db/a9f95e3794eca373d681220c8b9f8f84451a0d14959f85cc341ca592394c/mlx_audio-0.4.3.tar.gz"
  sha256 "8e87badf56a0f73bf91e3797b1195c01440a181cf0b64a2a08dc1bda4b037f54"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-audio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "150191095a60868f22c259eb4c479b9401f969400feb87b0daf4616c561e4560"
    sha256 arm64_sequoia: "78a0d575daf048edf7aba274710ae5a65f127ec9969665e1c78e4669d80671fb"
    sha256 arm64_sonoma:  "5734f87e6ac73b08119f310514cbe00c1100bcedb23f892473c91a7e84d56db8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "gcc" # for gfortran
  depends_on "libomp"
  depends_on "libsndfile"
  depends_on "llvm@20"
  depends_on macos: :sonoma
  depends_on :macos
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[
    certifi
    fastapi
    mlx
    mlx-lm
    numpy
    protobuf
    uvicorn
  ]

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/76/96/9129106469f477af798019f0c6064fe42c795ef4a4d8a4637124fb1ea017/miniaudio-1.70.tar.gz"
    sha256 "f788504ee2b8ad3092f34b13d72875dba50597a3d25d8af3ac2f8573d31d8c31"
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

  def install
    ENV["LLVMLITE_SHARED"] = "1"

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    venv.pip_install_and_link buildpath

    mlx_lm_site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["mlx-lm"].opt_libexec/mlx_lm_site_packages}')\n"
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
    assert_match "Convert HuggingFace model (TTS, STT, or STS) to MLX format",
                 shell_output("#{bin}/mlx_audio.convert --help")
    assert_match "Generate transcriptions from audio files",
                 shell_output("#{bin}/mlx_audio.stt.generate --help")

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
