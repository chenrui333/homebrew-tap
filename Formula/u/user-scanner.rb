class UserScanner < Formula
  include Language::Python::Virtualenv

  desc "Check username availability across multiple popular platforms"
  homepage "https://github.com/kaifcodec/user-scanner"
  url "https://files.pythonhosted.org/packages/a6/bf/a7efb0d0bb291f53332a60165eff13169dc58b0a0405fb32127ddb78a7ab/user_scanner-1.5.1.1.tar.gz"
  sha256 "7fbd6be312a74b4fdd5462e5021c92b250c218833168fd7357e7d695fa75cc08"
  license "MIT"
  head "https://github.com/kaifcodec/user-scanner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d44694563358ede162994a6d0fbcdb4fc8947a7b137a00bc81e74476d38968c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a23bd36c43af54e12ef11860888cabc96202cb74c3d411b700d73e3403ce2776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c0052361eeb016320853f55f85093916d744a3e218e6966646ca1cb14c7eab"
    sha256 cellar: :any,                 arm64_linux:   "b52b7495121a1dc2a2c1f4e5a6e049f233fb28c98ac2ebfc690dfcf5c9127063"
    sha256 cellar: :any,                 x86_64_linux:  "8834415410efb05680320960c47cb9d94be187b59671d826769cfd2996c40a66"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libffi"
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/d1/f6/347067dfacb19e44a4166d7bdb183e3a2629680beceb5e52f7cb2cc1a3b4/curl_cffi-0.16.2.tar.gz"
    sha256 "2986a86cdcf514ab73632c2de62a01db3cc97f7ecf17798a1be16180f4474198"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
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

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "socksio" do
    url "https://files.pythonhosted.org/packages/f8/5c/48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85/socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/user-scanner --version")

    usernames = testpath/"usernames.txt"
    usernames.write("alice\n# comment\n\nbob\n")

    (testpath/"test.py").write <<~PY
      import contextlib
      import io
      import sys
      from unittest.mock import patch

      from user_scanner.__main__ import main
      from user_scanner.core.result import Result

      def fake_run_user_module(module, target, config, **kwargs):
          return [Result.taken(username=target, site_name="Github", is_email=False)]

      buffer = io.StringIO()
      with (
          patch("user_scanner.__main__.check_for_updates", lambda: None),
          patch("user_scanner.__main__.print_banner", lambda: None),
          patch("user_scanner.__main__.run_user_module", fake_run_user_module),
          contextlib.redirect_stdout(buffer),
      ):
          sys.argv = ["user-scanner", "-uf", #{usernames.to_s.inspect}, "-m", "github"]
          try:
              main()
              exit_code = 0
          except SystemExit as exc:
              exit_code = exc.code

      output = buffer.getvalue()
      assert exit_code == 0, output
      assert "Loaded 2 usernames" in output, output
      assert "Scan complete." in output, output
    PY

    system libexec/"bin/python", testpath/"test.py"
  end
end
