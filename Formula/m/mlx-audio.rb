class MlxAudio < Formula
  include Language::Python::Virtualenv

  desc "Run audio models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-audio"
  url "https://files.pythonhosted.org/packages/e7/02/40b042713edf6f8f7714f711a2fc5191b871c4c39d79df6e7726de6a81e9/mlx_audio-0.4.6.tar.gz"
  sha256 "9f377ba4c0927af06526ed2d03b2fa44eb158d83385da96422da17c926b8589f"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-audio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "7343be5aa533a768c3b26d08672146ae16c3d74c5efee949d75126696e20b8f5"
    sha256 arm64_sequoia: "4a5ec486844fc00a0e1700cbb99639cd11ea49296acf6fe3ab946237364e6e21"
    sha256 arm64_sonoma:  "540cff1c71b8eef8b3048430015b1cb11702ded4432de88953a1ac28bd44d4cd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "gcc" # for gfortran
  depends_on "libomp"
  depends_on "libsndfile"
  depends_on "llvm@20"
  depends_on :macos
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "python@3.14"

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
    uvicorn
  ]

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/57/5f/ff100cae70ebe9d8df1c01a00e510e45d9adb5c1fdda84791b199141de97/cffi-2.1.0.tar.gz"
    sha256 "efc1cdd798b1aaf39b4610bba7aad28c9bea9b910f25c784ccf9ec1fa719d1f9"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/d8/d5/e5439dc08561f73656bfeb3340fc64ab63163e101426593d8fb9a025ff1e/miniaudio-1.71.tar.gz"
    sha256 "ff51e2887bb673e2e757752b586b3dc924d59aa5fbcae9bbc45f4a111bd3262b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/a7/25/c2700dfaf6442b4effaa91af24ebce5dc9d31bb4a69706313aae70d72cd0/scipy-1.18.0.tar.gz"
    sha256 "67b2ad2ad54c72ca6d04975a9b2df8c3638c34ddd5b28738e94fc2b57929d378"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/2a/f9/2592608737553638fca98e21e54bfec40bf577bb98a61b2770c912aab25e/sounddevice-0.5.5.tar.gz"
    sha256 "22487b65198cb5bf2208755105b524f78ad173e5ab6b445bdab1c989f6698df3"
  end

  def install
    ENV["LLVMLITE_SHARED"] = "1"

    # Work around upstream circular import: https://github.com/Blaizzy/mlx-audio/issues/828
    inreplace "mlx_audio/stt/models/__init__.py", /\A.*\z/m, ""

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
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
