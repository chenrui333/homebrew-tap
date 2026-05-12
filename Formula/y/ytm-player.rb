class YtmPlayer < Formula
  include Language::Python::Virtualenv

  desc "YouTube Music TUI client with vim keybindings and synced lyrics"
  homepage "https://github.com/peternaame-boop/ytm-player"
  url "https://github.com/peternaame-boop/ytm-player/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "6eeb105e902b43648d50d8f23392861a72aa43b9e4fee0cae10bddb0902f526d"
  license "MIT"
  head "https://github.com/peternaame-boop/ytm-player.git", branch: "master"

  depends_on "mpv"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/25/ee/6caf7a40c36a1220410afe15a1cc64993a1f864871f698c0f93acb72842a/certifi-2026.4.22.tar.gz"
    sha256 "8d455352a37b71bf76a79caa83a3d6c25afee4a385d632127b6afb3963f1c580"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/d8/3d/e0e8d9d1cee04f758120915e2b2a3a07eb41f8cf4654b4734788a522bcd1/mdit_py_plugins-0.6.0.tar.gz"
    sha256 "2436f14a7295837ac9228a36feeabda867c4abc488c8d019ad5c0bda88eee040"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/5c/94/a111239b98260869780a5767e5d74bfd3a8c13a40457f479c28dcd91f89d/pyobjc_core-11.0.tar.gz"
    sha256 "63bced211cb8a8fb5c8ff46473603da30e51112861bd02c438fbbbc8578d9a70"
  end

  resource "pyobjc-framework-avfoundation" do
    url "https://files.pythonhosted.org/packages/76/06/018ad0e2a38dbdbc5c126d7ce37488c4d581d4e2a2b9ef678162bb36d5f6/pyobjc_framework_avfoundation-11.0.tar.gz"
    sha256 "269a592bdaf8a16948d8935f0cf7c8cb9a53e7ea609a963ada0e55f749ddb530"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/c5/32/53809096ad5fc3e7a2c5ddea642590a5f2cb5b81d0ad6ea67fdb2263d9f9/pyobjc_framework_cocoa-11.0.tar.gz"
    sha256 "00346a8cb81ad7b017b32ff7bf596000f9faa905807b1bd234644ebd47f692c5"
  end

  resource "pyobjc-framework-coreaudio" do
    url "https://files.pythonhosted.org/packages/31/e6/3b7a8af3defec012d6cacf277fd8d5c3e254ceace63a05447dc1119f3a7e/pyobjc_framework_coreaudio-11.0.tar.gz"
    sha256 "38b6b531381119be6998cf704d04c9ea475aaa33f6dd460e0584351475acd0ae"
  end

  resource "pyobjc-framework-coremedia" do
    url "https://files.pythonhosted.org/packages/02/60/7c7b9f13c94910882de6cc08f48a52cce9739e75cc3b3b6de5c857e6536a/pyobjc_framework_coremedia-11.0.tar.gz"
    sha256 "a414db97ba30b43c9dd96213459d6efb169f9e92ce1ad7a75516a679b181ddfb"
  end

  resource "pyobjc-framework-mediaplayer" do
    url "https://files.pythonhosted.org/packages/a2/ce/3d2783f2f96ddf51bebcf6537a4a0f2a8a1fe4e520de218fc1b7c5b219ed/pyobjc_framework_mediaplayer-11.0.tar.gz"
    sha256 "c61be0ba6c648db6b1d013a52f9afb8901a8d7fbabd983df2175c1b1fbff81e5"
  end

  resource "pyobjc-framework-quartz" do
    url "https://files.pythonhosted.org/packages/a5/ad/f00f3f53387c23bbf4e0bb1410e11978cbf87c82fa6baff0ee86f74c5fb6/pyobjc_framework_quartz-11.0.tar.gz"
    sha256 "3205bf7795fb9ae34747f701486b3db6dfac71924894d1f372977c4d70c3c619"
  end

  resource "python-mpv" do
    url "https://files.pythonhosted.org/packages/77/bc/6aa34c8805ff62e2fefc7d171563c60598aac215d5241186031a2c839935/python_mpv-1.0.8.tar.gz"
    sha256 "017fa359da059c831a94c419083491903e6d2f7c81b9841c33c196cabf4b3fe3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/62/1e/1eedc5bac184d00aaa5f9a99095f7e266af3ec46fa926c1051be5d358da1/textual-8.2.5.tar.gz"
    sha256 "6c894e65a879dadb4f6cf46ddcfedb0173ff7e0cb1fe605ff7b357a597bdbc90"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/8b/34/7c6b4e3f89cb6416d2cd7ab6dab141a1df97ab0fb22d15816db2c92148c9/yt_dlp-2026.3.17.tar.gz"
    sha256 "ba7aa31d533f1ffccfe70e421596d7ca8ff0bf1398dc6bb658b7d9dec057d2c9"
  end

  resource "ytmusicapi" do
    url "https://files.pythonhosted.org/packages/4f/16/728305b1e6d100f2f2c696f6de08b3717f3db323bd666a8246397d70bcad/ytmusicapi-1.12.0.tar.gz"
    sha256 "9a466e633c43e90025b4c3dfa862f0f5677af4eacc8d2052ef9fc8f48cd65140"
  end

  def install
    ENV["PIP_BUILD_ISOLATION"] = "false"
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ytm --version 2>&1")
  end
end
