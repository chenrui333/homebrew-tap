class MlxAudio < Formula
  include Language::Python::Virtualenv

  desc "Run audio models on Apple silicon with MLX"
  homepage "https://github.com/Blaizzy/mlx-audio"
  url "https://files.pythonhosted.org/packages/06/0f/5a6c43517d5c7a7200674c993df13c80d9b10311d83a2f83b45f028b3fff/mlx_audio-0.4.1.tar.gz"
  sha256 "e16260255324feb603d70925584d48421c7581943ec9a71f36d149cdbab302d8"
  license "MIT"
  head "https://github.com/Blaizzy/mlx-audio.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "fbee24078b68f5d3b5c1b71c00e199ade2f478d8c2b348e396af4d45609ef5b8"
    sha256 cellar: :any, arm64_sequoia: "b97657ace4288799246bf27c342030e95acdd953b97ec42c21a74ab3db2bff80"
    sha256 cellar: :any, arm64_sonoma:  "4d8fa24ec0916eeacceec91729706992c666459ee6668f9dc4fd0ec009b441b7"
  end

  depends_on arch: :arm64
  depends_on "certifi" => :no_linkage
  depends_on "libsndfile"
  depends_on macos: :sonoma
  depends_on :macos
  depends_on "mlx"
  depends_on "mlx-lm"
  depends_on "numpy"
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

  resource "audioop-lts" do
    url "https://files.pythonhosted.org/packages/38/53/946db57842a50b2da2e0c1e34bd37f36f5aadba1a929a3971c5d7841dbca/audioop_lts-0.2.2.tar.gz"
    sha256 "64d0c62d88e67b98a1a5e71987b7aa7b5bcffc7dcee65b635823dbdd0a8dbbd0"
  end

  resource "audioread" do
    url "https://files.pythonhosted.org/packages/a1/4a/874ecf9b472f998130c2b5e145dcdb9f6131e84786111489103b66772143/audioread-3.1.0.tar.gz"
    sha256 "1c4ab2f2972764c896a8ac61ac53e261c8d29f0c6ccd652f84e18f08a4cab190"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/41/f2/d34e8b3a08a9cc79a50b2208a93dce981fe615b64d5a4d4abee421d898df/joblib-1.5.3.tar.gz"
    sha256 "8561a3269e6801106863fd0d6d84bb737be9e7631e33aaed3fb9ce5953688da3"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/49/ac/21a1f8aa3777f5658576777ea76bfb124b702c520bbe90edf4ae9915eafa/lazy_loader-0.5.tar.gz"
    sha256 "717f9179a0dbed357012ddad50a5ad3d5e4d9a0b8712680d4e687f5e6e6ed9b3"
  end

  resource "librosa" do
    url "https://files.pythonhosted.org/packages/64/36/360b5aafa0238e29758729e9486c6ed92a6f37fa403b7875e06c115cdf4a/librosa-0.11.0.tar.gz"
    sha256 "f5ed951ca189b375bbe2e33b2abd7e040ceeee302b9bbaeeffdfddb8d0ace908"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/95/ae/af0ffb724814cc2ea64445acad05f71cff5f799bb7efb22e47ee99340dbc/llvmlite-0.46.0-cp314-cp314-macosx_12_0_arm64.whl"
    sha256 "d252edfb9f4ac1fcf20652258e3f102b26b03eef738dc8a6ffdab7d7d341d547"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/55/fa/96d4cc7ada283357117f7890418ac065a0a6d81ec59e681cd965a403aba3/miniaudio-1.61.tar.gz"
    sha256 "e88e97837d031f0fb6982394218b6487de02eaa382ad273b8fca37791a2b4b15"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/4d/f2/bfb55a6236ed8725a96b0aa3acbd0ec17588e6a2c3b62a93eb513ed8783f/msgpack-1.1.2.tar.gz"
    sha256 "3b60763c1373dd60f398488069bcdc703cd08a711477b5d480eecc9f9626f47e"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/3d/8a/77d26afe0988c592dd97cb8d4e80bfb3dfc7dbdacfca7d74a7c5c81dd8c2/numba-0.64.0-cp314-cp314-macosx_12_0_arm64.whl"
    sha256 "f565d55eaeff382cbc86c63c8c610347453af3d1e7afb2b6569aac1c9b5c93ce"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pooch" do
    url "https://files.pythonhosted.org/packages/83/43/85ef45e8b36c6a48546af7b266592dc32d7f67837a6514d111bced6d7d75/pooch-1.9.0.tar.gz"
    sha256 "de46729579b9857ffd3e741987a2f6d5e0e03219892c167c6578c0091fb511ed"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pyloudnorm" do
    url "https://files.pythonhosted.org/packages/23/00/f915eaa75326f4209941179c2b93ac477f2040e4aeff5bb21d16eb8058f9/pyloudnorm-0.2.0.tar.gz"
    sha256 "8bf597658ea4e1975c275adf490f6deb5369ea409f2901f939915efa4b681b16"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "scikit-learn" do
    url "https://files.pythonhosted.org/packages/a8/25/01c0af38fe969473fb292bba9dc2b8f9b451f3112ff242c647fee3d0dfe7/scikit_learn-1.8.0-cp314-cp314-macosx_12_0_arm64.whl"
    sha256 "6b595b07a03069a2b1740dc08c2299993850ea81cce4fe19b2421e0c970de6b7"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/ed/a6/d05a85fd51daeb2e4ea71d102f15b34fedca8e931af02594193ae4fd25f7/scipy-1.17.1-cp314-cp314-macosx_12_0_arm64.whl"
    sha256 "45abad819184f07240d8a696117a7aacd39787af9e0b719d00285549ed19a1e9"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/4e/4f/28e734898b870db15b6474453f19813d3c81b91c806d9e6f867bd6e4dd03/sounddevice-0.5.3.tar.gz"
    sha256 "cbac2b60198fbab84533697e7c4904cc895ec69d5fb3973556c9eb74a4629b2c"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/e1/41/9b873a8c055582859b239be17902a85339bec6a30ad162f98c9b0288a2cc/soundfile-0.13.1.tar.gz"
    sha256 "b2c68dab1e30297317080a5b43df57e302584c49e2942defdde0acccc53f0e5b"
  end

  resource "soxr" do
    url "https://files.pythonhosted.org/packages/42/7e/f4b461944662ad75036df65277d6130f9411002bfb79e9df7dff40a31db9/soxr-1.0.0.tar.gz"
    sha256 "e07ee6c1d659bc6957034f4800c60cb8b98de798823e34d2a2bba1caa85a4509"
  end

  resource "standard-aifc" do
    url "https://files.pythonhosted.org/packages/c4/53/6050dc3dde1671eb3db592c13b55a8005e5040131f7509cef0215212cb84/standard_aifc-3.13.0.tar.gz"
    sha256 "64e249c7cb4b3daf2fdba4e95721f811bde8bdfc43ad9f936589b7bb2fae2e43"
  end

  resource "standard-chunk" do
    url "https://files.pythonhosted.org/packages/43/06/ce1bb165c1f111c7d23a1ad17204d67224baa69725bb6857a264db61beaf/standard_chunk-3.13.0.tar.gz"
    sha256 "4ac345d37d7e686d2755e01836b8d98eda0d1a3ee90375e597ae43aaf064d654"
  end

  resource "standard-sunau" do
    url "https://files.pythonhosted.org/packages/66/e3/ce8d38cb2d70e05ffeddc28bb09bad77cfef979eb0a299c9117f7ed4e6a9/standard_sunau-3.13.0.tar.gz"
    sha256 "b319a1ac95a09a2378a8442f403c66f4fd4b36616d6df6ae82b8e536ee790908"
  end

  resource "threadpoolctl" do
    url "https://files.pythonhosted.org/packages/b7/4d/08c89e34946fce2aec4fbb45c9016efd5f4d7f24af8e5d93296e935631d8/threadpoolctl-3.6.0.tar.gz"
    sha256 "8ab8b4aa3491d812b623328249fab5302a68d2d71745c8a4c719a2fcaba9f44e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    wheel_resources = %w[llvmlite numba scikit-learn scipy]
    venv = virtualenv_create(libexec, "python3.14")

    venv.pip_install resources.reject { |resource| wheel_resources.include?(resource.name) }

    wheel_resources.each do |resource_name|
      wheel_resource = resource(resource_name)
      wheel_resource.stage do
        venv.pip_install Pathname.pwd/wheel_resource.downloader.basename
      end
    end

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

      assert version("mlx-audio") == "0.4.1"
      assert format_timestamp(61.234) == "00:01:01,234"
      assert format_vtt_timestamp(61.234) == "00:01:01.234"
    PYTHON

    system libexec/"bin/python", "test.py"
  end
end
