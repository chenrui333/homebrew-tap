class UserScanner < Formula
  include Language::Python::Virtualenv

  desc "Check username availability across multiple popular platforms"
  homepage "https://github.com/kaifcodec/user-scanner"
  url "https://files.pythonhosted.org/packages/73/8b/3eedd7ab77218729f437e3599ea5e0ba2983481c85cb6b095f563494ab3d/user_scanner-1.4.1.6.tar.gz"
  sha256 "3a9d78c7140e717e0f6b0cf7ef23c658d42bbf628b47c9cdfa2a0af4a64c8852"
  license "MIT"
  head "https://github.com/kaifcodec/user-scanner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "95c1808f249c50bbe18198baf248506bc3132fe0def447341f1a992bd6192c57"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c9/c7/424b75da314c1045981bd9777432fad05a9e0c69daa4ed7e308bbaffe405/certifi-2026.6.17.tar.gz"
    sha256 "024c88eeec92ca068db80f02b8b07c9cef7b9fe261d1d535abfd5abd6f6af432"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/1d/17/afa56379f94ad0fe8defd37d6eb3f89a25404ffc71d4d848893d270325fc/h2-4.3.0.tar.gz"
    sha256 "6c59efe4323fa18b47a632221a1888bd7fde6249819beda254aeca909f221bf1"
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
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
