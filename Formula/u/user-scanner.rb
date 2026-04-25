class UserScanner < Formula
  include Language::Python::Virtualenv

  desc "Check username availability across multiple popular platforms"
  homepage "https://github.com/kaifcodec/user-scanner"
  url "https://files.pythonhosted.org/packages/84/01/81407134ef71dacdcef225f1be3f90ada52c2308a748c244b39fd2add0a4/user_scanner-1.3.5.9.tar.gz"
  sha256 "c33e0107cddc1a70a4fd83bf461fe087c01f0a38a617f6536ffd84d3ef6358cb"
  license "MIT"
  head "https://github.com/kaifcodec/user-scanner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "f6fccda52f3679bc95919894ccaad46b336fd6855d1f41c3392df601ed54707c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/25/ee/6caf7a40c36a1220410afe15a1cc64993a1f864871f698c0f93acb72842a/certifi-2026.4.22.tar.gz"
    sha256 "8d455352a37b71bf76a79caa83a3d6c25afee4a385d632127b6afb3963f1c580"
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
    url "https://files.pythonhosted.org/packages/2c/48/71de9ed269fdae9c8057e5a4c0aa7402e8bb16f2c6e90b3aa53327b113f8/hpack-4.1.0.tar.gz"
    sha256 "ec5eca154f7056aa06f196a557655c5b009b382873ac8d1e66e79e87535f1dca"
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
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
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
