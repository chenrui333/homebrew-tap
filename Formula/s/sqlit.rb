class Sqlit < Formula
  include Language::Python::Virtualenv

  desc "User friendly TUI for SQL databases"
  homepage "https://github.com/Maxteabag/sqlit"
  url "https://files.pythonhosted.org/packages/e2/fc/35ea48f3b7ff6423be8998fbeb15de4e1770ab7467b00427e4f4e4a61821/sqlit_tui-1.3.1.tar.gz"
  sha256 "6038767912de5541984b534906a995ab1163ba253ab96945b51e5a0e37123541"
  license "MIT"
  head "https://github.com/Maxteabag/sqlit.git", branch: "main"

  depends_on "python@3.13"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e0/2d/a891ca51311197f6ad14a7ef42e2399f36cf2f9bd44752b3dc4eab60fdc5/certifi-2026.1.4.tar.gz"
    sha256 "ac726dd470482006e014ad384921ed6438c457018f4b3d204aea4281258b2120"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/cb/9c/a788f5bb29c61e456b8ee52ce76dbdd32fd72cd73dd67bc95f42c7a8d13c/jaraco_context-6.1.0.tar.gz"
    sha256 "129a341b0a85a7db7879e22acd66902fda67882db771754574338898b2d5d86f"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/76/21/7d2a95e4bba9dc13d043ee156a356c0a8f0c6309dff6b21b4d71a073b8a8/numpy-2.2.6.tar.gz"
    sha256 "e29554e2bef54a90aa5cc07da6ce955accb83f21ab5de01a62c8478897b264fd"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/33/01/d40b85317f86cf08d853a4f495195c73815fdf205eef3993821720274518/pandas-2.3.3.tar.gz"
    sha256 "e05e1af93b977f7eafa636d043f9f94c7ee3ac81af99c13508215942e64c993b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  if OS.mac? && Hardware::CPU.arm?
    resource "pyarrow" do
      url "https://files.pythonhosted.org/packages/16/ca/c7eaa8e62db8fb37ce942b1ea0c6d7abfe3786ca193957afa25e71b81b66/pyarrow-21.0.0-cp313-cp313-macosx_12_0_arm64.whl"
      sha256 "e99310a4ebd4479bcd1964dff9e14af33746300cb014aa4a3781738ac63baf4a"
    end
  elsif OS.mac?
    resource "pyarrow" do
      url "https://files.pythonhosted.org/packages/ce/e8/e87d9e3b2489302b3a1aea709aaca4b781c5252fcb812a17ab6275a9a484/pyarrow-21.0.0-cp313-cp313-macosx_12_0_x86_64.whl"
      sha256 "d2fe8e7f3ce329a71b7ddd7498b3cfac0eeb200c2789bd840234f0dc271a8efe"
    end
  elsif Hardware::CPU.arm?
    resource "pyarrow" do
      url "https://files.pythonhosted.org/packages/84/52/79095d73a742aa0aba370c7942b1b655f598069489ab387fe47261a849e1/pyarrow-21.0.0-cp313-cp313-manylinux_2_28_aarch64.whl"
      sha256 "f522e5709379d72fb3da7785aa489ff0bb87448a9dc5a75f45763a795a089ebd"
    end
  else
    resource "pyarrow" do
      url "https://files.pythonhosted.org/packages/89/4b/7782438b551dbb0468892a276b8c789b8bbdb25ea5c5eb27faadd753e037/pyarrow-21.0.0-cp313-cp313-manylinux_2_28_x86_64.whl"
      sha256 "69cbbdf0631396e9925e048cfa5bce4e8c3d3b41562bbd70c685a8eb53a91e61"
    end
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/90/76/437d71068094df0726366574cf3432a4ed754217b436eb7429415cf2d480/sqlparse-0.5.5.tar.gz"
    sha256 "e20d4a9b0b8585fdf63b10d30066c7c94c5d7a7ec47c889a2d83a3caa93ff28e"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/f7/08/1e1f705825359590ddfaeda57653bd518c4ff7a96bb2c3239ba1b6fc4c51/textual-8.0.0.tar.gz"
    sha256 "ce48f83a3d686c0fac0e80bf9136e1f8851c653aa6a4502e43293a151df18809"
  end

  resource "textual-fastdatatable" do
    url "https://files.pythonhosted.org/packages/1e/ec/8cc2204560200dcc80abc432a61eb6f99672049aecfd0860472cfc3f82fe/textual_fastdatatable-0.14.0.tar.gz"
    sha256 "cb99e208fb96c7eb5cfb7f225a280da950bd8cfb29d685a49071787c80218901"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/66/7c/0350cfc47faadc0d3cf7d8237a4e34032b3014ddf4a12ded9933e1648b55/tree-sitter-0.25.2.tar.gz"
    sha256 "fe43c158555da46723b28b52e058ad444195afd1db3ca7720c59a254544e9c20"
  end

  resource "tree-sitter-bash" do
    url "https://files.pythonhosted.org/packages/8e/0e/f0108be910f1eef6499eabce517e79fe3b12057280ed398da67ce2426cba/tree_sitter_bash-0.25.1.tar.gz"
    sha256 "bfc0bdaa77bc1e86e3c6652e5a6e140c40c0a16b84185c2b63ad7cd809b88f14"
  end

  resource "tree-sitter-css" do
    url "https://files.pythonhosted.org/packages/38/37/7d60171240d4c5ba330f05b725dfb5e5fd5b7cbe0aa98ef9e77f77f868f5/tree_sitter_css-0.25.0.tar.gz"
    sha256 "2fc996bf05b04e06061e88ee4c60837783dc4e62a695205acbc262ee30454138"
  end

  resource "tree-sitter-go" do
    url "https://files.pythonhosted.org/packages/01/05/727308adbbc79bcb1c92fc0ea10556a735f9d0f0a5435a18f59d40f7fd77/tree_sitter_go-0.25.0.tar.gz"
    sha256 "a7466e9b8d94dda94cae8d91629f26edb2d26166fd454d4831c3bf6dfa2e8d68"
  end

  if OS.mac? && Hardware::CPU.arm?
    resource "tree-sitter-html" do
      url "https://files.pythonhosted.org/packages/bd/17/827c315deb156bb8cac541da800c4bd62878f50a28b7498fbb722bddd225/tree_sitter_html-0.23.2-cp39-abi3-macosx_11_0_arm64.whl"
      sha256 "3d0a83dd6cd1c7d4bcf6287b5145c92140f0194f8516f329ae8b9e952fbfa8ff"
    end
  elsif OS.mac?
    resource "tree-sitter-html" do
      url "https://files.pythonhosted.org/packages/fb/27/b846852b567601c4df765bcb4636085a3260e9f03ae21e0ef2e7c7f957fc/tree_sitter_html-0.23.2-cp39-abi3-macosx_10_9_x86_64.whl"
      sha256 "9e1641d5edf5568a246c6c47b947ed524b5bf944664e6473b21d4ae568e28ee9"
    end
  elsif Hardware::CPU.arm?
    resource "tree-sitter-html" do
      url "https://files.pythonhosted.org/packages/91/cb/2028fe446d0e18edf3737d91edcb6430f2c97f2296b8cd760702dfa13d90/tree_sitter_html-0.23.2-cp39-abi3-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
      sha256 "81b3775732fffc0abd275a419ef018fd4c1ad4044b2a2e422f3378d93c30eded"
    end
  else
    resource "tree-sitter-html" do
      url "https://files.pythonhosted.org/packages/19/bc/b24f5e66be51447cf7e9bcce3d9440a6b4f17021da85779a51566646a7c7/tree_sitter_html-0.23.2-cp39-abi3-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
      sha256 "4bdaa7ac5030d416aea0c512d4810ef847bbbd62d61e3d213f370b64ce147293"
    end
  end

  resource "tree-sitter-java" do
    url "https://files.pythonhosted.org/packages/fa/dc/eb9c8f96304e5d8ae1663126d89967a622a80937ad2909903569ccb7ec8f/tree_sitter_java-0.23.5.tar.gz"
    sha256 "f5cd57b8f1270a7f0438878750d02ccc79421d45cca65ff284f1527e9ef02e38"
  end

  resource "tree-sitter-javascript" do
    url "https://files.pythonhosted.org/packages/59/e0/e63103c72a9d3dfd89a31e02e660263ad84b7438e5f44ee82e443e65bbde/tree_sitter_javascript-0.25.0.tar.gz"
    sha256 "329b5414874f0588a98f1c291f1b28138286617aa907746ffe55adfdcf963f38"
  end

  resource "tree-sitter-json" do
    url "https://files.pythonhosted.org/packages/d7/29/e92df6dca3a6b2ab1c179978be398059817e1173fbacd47e832aaff3446b/tree_sitter_json-0.24.8.tar.gz"
    sha256 "ca8486e52e2d261819311d35cf98656123d59008c3b7dcf91e61d2c0c6f3120e"
  end

  resource "tree-sitter-markdown" do
    url "https://files.pythonhosted.org/packages/9a/87/8f705d8f99337c8a691bcc8c22d89ddd323eb2b860a78ae2e894b9f7ade1/tree_sitter_markdown-0.5.1.tar.gz"
    sha256 "6c69d7270a7e09be8988ced44584c09a6a4f541cea0dc394dd1c1a5ac3b5601d"
  end

  resource "tree-sitter-python" do
    url "https://files.pythonhosted.org/packages/b8/8b/c992ff0e768cb6768d5c96234579bf8842b3a633db641455d86dd30d5dac/tree_sitter_python-0.25.0.tar.gz"
    sha256 "b13e090f725f5b9c86aa455a268553c65cadf325471ad5b65cd29cac8a1a68ac"
  end

  resource "tree-sitter-regex" do
    url "https://files.pythonhosted.org/packages/86/92/1767b833518d731b97c07cf616ea15495dcc0af584aa0381657be4ec446d/tree_sitter_regex-0.25.0.tar.gz"
    sha256 "5d29111b3f27d4afb31496476d392d1f562fe0bfe954e8968f1d8683424fc331"
  end

  resource "tree-sitter-rust" do
    url "https://files.pythonhosted.org/packages/8a/ae/fde1ab896f3d79205add86749f6f443537f59c747616a8fc004c7a453c29/tree_sitter_rust-0.24.0.tar.gz"
    sha256 "c7185f482717bd41f24ffcd90b5ee24e7e0d6334fecce69f1579609994cd599d"
  end

  resource "tree-sitter-sql" do
    url "https://files.pythonhosted.org/packages/e8/5c/3d10387f779f36835486167253682f61d5f4fd8336b7001da1ac7d78f31c/tree_sitter_sql-0.3.11.tar.gz"
    sha256 "700b93be2174c3c83d174ec3e10b682f72a4fb451f0076c7ce5012f1d5a76cbc"
  end

  resource "tree-sitter-toml" do
    url "https://files.pythonhosted.org/packages/59/b9/03ee757ac375e77186ea112c14fcf31e0ca70b27b6388d93dcceef61f029/tree_sitter_toml-0.7.0.tar.gz"
    sha256 "29e257612fa8f0c1fcbc4e7e08ddc561169f1725265302e64d81086354144a70"
  end

  resource "tree-sitter-xml" do
    url "https://files.pythonhosted.org/packages/41/ba/77a92dbb4dfb374fb99863a07f938de7509ceeaa74139933ac2bd306eeb1/tree_sitter_xml-0.7.0.tar.gz"
    sha256 "ab0ff396f20230ad8483d968151ce0c35abe193eb023b20fbd8b8ce4cf9e9f61"
  end

  resource "tree-sitter-yaml" do
    url "https://files.pythonhosted.org/packages/57/b6/941d356ac70c90b9d2927375259e3a4204f38f7499ec6e7e8a95b9664689/tree_sitter_yaml-0.7.2.tar.gz"
    sha256 "756db4c09c9d9e97c81699e8f941cb8ce4e51104927f6090eefe638ee567d32c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")

    resources.each do |resource|
      next if resource.name == "pyarrow" || resource.name.start_with?("tree-sitter")

      venv.pip_install resource
    end

    pyarrow_wheel = buildpath/File.basename(resource("pyarrow").url.to_s)
    cp resource("pyarrow").cached_download, pyarrow_wheel
    venv.pip_install pyarrow_wheel
    venv.pip_install_and_link buildpath
  end

  test do
    db_path = testpath/"sample.db"

    system bin/"sqlit", "connections", "add", "sqlite",
           "--name", "local",
           "--file-path", db_path.to_s

    output = shell_output("#{bin}/sqlit query --connection local --query 'SELECT 1 AS n' --format json")
    assert_match "\"n\": 1", output
  end
end
