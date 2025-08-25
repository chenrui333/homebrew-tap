class Docling < Formula
  include Language::Python::Virtualenv

  desc "Get your documents ready for gen AI"
  homepage "https://docling-project.github.io/docling/"
  url "https://files.pythonhosted.org/packages/f4/9f/a508c77c279e7138bf3c2e2aa6502fda3e3149e117bd06573a8ab029c528/docling-2.47.1.tar.gz"
  sha256 "d82c20f316d34dbb0e86b9bda1af6e51f435592e5063bc377d112d8e46398158"
  license "MIT"

  depends_on "cmake" => :build # for docling_parse
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "geos" # for shapely
  depends_on "libyaml"
  depends_on "numpy" # for shapely
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "scikit-image"
  depends_on "scipy"
  depends_on "torchvision"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build # for shapely
  end

  resource "accelerate" do
    url "https://files.pythonhosted.org/packages/b1/72/ff3961c19ee395c3d30ac630ee77bfb0e1b46b87edc504d4f83bb4a89705/accelerate-1.10.1.tar.gz"
    sha256 "3dea89e433420e4bfac0369cae7e36dcd6a56adfcfd38cdda145c6225eab5df8"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/85/2e/3e5079847e653b1f6dc647aa24549d68c6addb4c595cc0d902d1b19308ad/beautifulsoup4-4.13.5.tar.gz"
    sha256 "5e70131382930e7c3de33450a2f54a63d5e4b19386eab43a5b34d594268f3695"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/12/80/630b4b88364e9a8c8c5797f4602d0f76ef820909ee32f0bacb9f90654042/dill-0.4.0.tar.gz"
    sha256 "0633f1d2df477324f53a895b02c901fb961bdbf65a17122586ea7019292cbcf0"
  end

  resource "docling-core" do
    url "https://files.pythonhosted.org/packages/57/e8/957a263fa00e8e0185589e36812f904618a597d77656187202f4b6bc78f1/docling_core-2.45.0.tar.gz"
    sha256 "21ae79263f234ec5ed660b0b508019480adf16ddfa81cea60cd3a9f986f9abf1"
  end

  resource "docling-ibm-models" do
    url "https://files.pythonhosted.org/packages/15/4e/8fdc66af4390d4cfa6ecfe27a03bdbacde96f80dda4baff7f01f5dae8b04/docling_ibm_models-3.9.0.tar.gz"
    sha256 "e3f866371df86a85abc2ae88fa05a9e56e3ae3b5e6512bec9cc5b6e12096af50"
  end

  resource "docling-parse" do
    url "https://files.pythonhosted.org/packages/0b/90/ecb0eca0e8fe5782f94091bb5a31287f2c132a9f2f4e37161b1436380997/docling_parse-4.2.3.tar.gz"
    sha256 "721f7a1e22148b68c7a760b6815cee731a1fc5edb70208de9130696cd5e65c8c"

    patch :DATA
  end

  resource "easyocr" do
    url "https://files.pythonhosted.org/packages/bb/84/4a2cab0e6adde6a85e7ba543862e5fc0250c51f3ac721a078a55cdcff250/easyocr-1.7.2-py3-none-any.whl"
    sha256 "5be12f9b0e595d443c9c3d10b0542074b50f0ec2d98b141a109cd961fd1c177c"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/7a/49/91010b59debc7c862a5fd426d343134dd9a68778dbe570234b6495a4e204/hf_xet-1.1.8.tar.gz"
    sha256 "62a0043e441753bbc446dcb5a3fe40a4d03f5fb9f13589ef1df9ab19252beb53"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/45/c9/bdbe19339f76d12985bc03572f330a01a93c04dffecaaea3061bdd7fb892/huggingface_hub-0.34.4.tar.gz"
    sha256 "a4228daa6fb001be3f4f4bdaf9a0db00e1739235702848df00885c9b5742c85c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/2a/c8/efdb87403dae07cf20faf75449eae41898b71d6a8d4ebaf9c80d5be215f5/jsonlines-3.1.0.tar.gz"
    sha256 "2579cb488d96f815b0eb81629e3e6b0332da0962a18fa3532958f7ba14a5c37f"
  end

  resource "jsonref" do
    url "https://files.pythonhosted.org/packages/aa/0d/c1f3277e90ccdb50d33ed5ba1ec5b3f0a242ed8c1b1a85d3afeb68464dca/jsonref-1.1.0.tar.gz"
    sha256 "32fe8e1d85af0fdefbebce950af85590b22b60f9e95443176adbde4e1ecea552"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "latex2mathml" do
    url "https://files.pythonhosted.org/packages/69/33/ad2c3929494ad160f5130ea132ca298627a6c81c70be6bedd1bc806b5b01/latex2mathml-3.78.0.tar.gz"
    sha256 "712193aa4c6ade1a8e0145dac7bc1f9aafbd54f93046a2356a7e1c05fa0f8b31"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "marko" do
    url "https://files.pythonhosted.org/packages/9c/6a/32545d2379822fb9a8843f01150011402888492541977a1193fe8d695df0/marko-2.2.0.tar.gz"
    sha256 "213c146ba197c1d6bcb06ae3658b7d87e45f6def35c09905b86aa6bb1984eba6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mpire" do
    url "https://files.pythonhosted.org/packages/3a/93/80ac75c20ce54c785648b4ed363c88f148bf22637e10c9863db4fbe73e74/mpire-2.10.2.tar.gz"
    sha256 "f66a321e93fadff34585a4bfa05e95bd946cf714b442f51c529038eb45773d97"
  end

  resource "multiprocess" do
    url "https://files.pythonhosted.org/packages/72/fd/2ae3826f5be24c6ed87266bc4e59c46ea5b059a103f3d7e7eb76a52aeecb/multiprocess-0.70.18.tar.gz"
    sha256 "f9597128e6b3e67b23956da07cf3d2e5cba79e2f4e0fba8d7903636663ec6d0d"
  end

  resource "ninja" do
    url "https://files.pythonhosted.org/packages/43/73/79a0b22fc731989c708068427579e840a6cf4e937fe7ae5c5d0b7356ac22/ninja-1.13.0.tar.gz"
    sha256 "4a40ce995ded54d9dc24f8ea37ff3bf62ad192b547f6c7126e7e25045e76f978"
  end

  resource "opencv-python-headless" do
    url "https://files.pythonhosted.org/packages/a4/63/6861102ec149c3cd298f4d1ea7ce9d6adbc7529221606ff1dab991a19adb/opencv-python-headless-4.12.0.88.tar.gz"
    sha256 "cfdc017ddf2e59b6c2f53bc12d74b6b0be7ded4ec59083ea70763921af2b6c09"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/79/8e/0e90233ac205ad182bd6b422532695d2b9414944a280488105d598c70023/pandas-2.3.2.tar.gz"
    sha256 "ab7b58f8f82706890924ccdfb5f48002b83d2b5a3845976a9fb705d36c34dcdb"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyclipper" do
    url "https://files.pythonhosted.org/packages/4a/b2/550fe500e49c464d73fabcb8cb04d47e4885d6ca4cfc1f5b0a125a95b19a/pyclipper-1.3.0.post6.tar.gz"
    sha256 "42bff0102fa7a7f2abdd795a2594654d62b786d0c6cd67b72d469114fdeb608c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/00/dd/4325abf92c39ba8623b5af936ddb36ffcfe0beae70405d456ab1fb2f5b8c/pydantic-2.11.7.tar.gz"
    sha256 "d989c3c6cb79469287b1569f7447a17848c998458d49ebe294e975b9baf0f0db"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/68/85/1ea668bbab3c50071ca613c6ab30047fb36ab0da1b92fa8f17bbc38fd36c/pydantic_settings-2.10.1.tar.gz"
    sha256 "06f0062169818d0f5524420a360d632d5857b83cffd4d42fe29597807a1614ee"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pylatexenc" do
    url "https://files.pythonhosted.org/packages/5d/ab/34ec41718af73c00119d0351b7a2531d2ebddb51833a36448fc7b862be60/pylatexenc-2.10.tar.gz"
    sha256 "3dd8fd84eb46dc30bee1e23eaab8d8fb5a7f507347b23e5f38ad9675c84f40d3"
  end

  resource "pypdfium2" do
    url "https://files.pythonhosted.org/packages/a1/14/838b3ba247a0ba92e4df5d23f2bea9478edcfd72b78a39d6ca36ccd84ad2/pypdfium2-4.30.0.tar.gz"
    sha256 "48b5b7e5566665bc1015b9d69c1ebabe21f6aee468b509531c3c8318eeee2e16"
  end

  resource "python-bidi" do
    url "https://files.pythonhosted.org/packages/c4/de/1822200711beaadb2f334fa25f59ad9c2627de423c103dde7e81aedbc8e2/python_bidi-0.6.6.tar.gz"
    sha256 "07db4c7da502593bd6e39c07b3a38733704070de0cbf92a7b7277b7be8867dd9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-docx" do
    url "https://files.pythonhosted.org/packages/a9/f7/eddfe33871520adab45aaa1a71f0402a2252050c14c7e3009446c8f4701c/python_docx-1.2.0.tar.gz"
    sha256 "7bc9d7b7d8a69c9c02ca09216118c86552704edc23bac179283f2e38f86220ce"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "python-pptx" do
    url "https://files.pythonhosted.org/packages/52/a9/0c0db8d37b2b8a645666f7fd8accea4c6224e013c42b1d5c17c93590cd06/python_pptx-1.0.2.tar.gz"
    sha256 "479a8af0eaf0f0d76b6f00b0887732874ad2e3188230315290cd1f9dd9cc7095"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/0b/de/e13fa6dc61d78b30ba47481f99933a3b49a57779d625c392d8036770a60d/regex-2025.7.34.tar.gz"
    sha256 "9ead9765217afd04a86822dfcd4ed2747dfe426e887da413b15ff0ac2457e21a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/1e/d9/991a0dee12d9fc53ed027e26a26a64b151d77252ac477e22666b9688bc16/rpds_py-0.27.0.tar.gz"
    sha256 "8b23cf252f180cda89220b378d917180f29d313cd6a07b2431c0d3b776aae86f"
  end

  resource "rtree" do
    url "https://files.pythonhosted.org/packages/95/09/7302695875a019514de9a5dd17b8320e7a19d6e7bc8f85dcfb79a4ce2da3/rtree-1.4.1.tar.gz"
    sha256 "c6b1b3550881e57ebe530cc6cffefc87cd9bf49c30b37b894065a9f810875e46"
  end

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/ac/cc/738f3011628920e027a11754d9cae9abec1aed00f7ae860abbf843755233/safetensors-0.6.2.tar.gz"
    sha256 "43ff2aa0e6fa2dc3ea5524ac7ad93a9839256b8703761e76e2d0b2a3fa4f15d9"
  end

  resource "semchunk" do
    url "https://files.pythonhosted.org/packages/62/96/c418c322730b385e81d4ab462e68dd48bb2dbda4d8efa17cad2ca468d9ac/semchunk-2.2.2.tar.gz"
    sha256 "940e89896e64eeb01de97ba60f51c8c7b96c6a3951dfcf574f25ce2146752f52"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/ca/3c/2da625233f4e605155926566c0e7ea8dda361877f48e8b1655e53456f252/shapely-2.1.1.tar.gz"
    sha256 "500621967f2ffe9642454808009044c21e5b35db89ce69f8a2042c2ffd0e2772"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3f/f4/4a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19f/soupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c2/2f/402986d0823f8d7ca139d969af2917fefaa9b947d1fb32f6168c509f2492/tokenizers-0.21.4.tar.gz"
    sha256 "fa23f85fbc9a02ec5c6978da172cdcbac23498c3ca9f3645c5c68740ac007880"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/2b/43/3cb831d5f28cc723516e5bb43a8c6042aca3038bb36b6bd6016b40dfd1e8/transformers-4.55.4.tar.gz"
    sha256 "574a30559bc273c7a4585599ff28ab6b676e96dc56ffd2025ecfce2fd0ab915d"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/43/78/d90f616bf5f88f8710ad067c1f8705bf7618059836ca084e5bb2a0855d75/typer-0.16.1.tar.gz"
    sha256 "d358c65a464a7a90f338e3bb7ff0c74ac081449e53884b12ba658cbd72990614"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/f8/b1/0c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238/typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/a7/47/7704bac42ac6fe1710ae099b70e6a1e68ed173ef14792b647808c357da43/xlsxwriter-3.2.5.tar.gz"
    sha256 "7e88469d607cdc920151c0ab3ce9cf1a83992d4b7bc730c5ffdd1a12115a7dbe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docling --version")
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index bb633e9..216bcd6 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -41,7 +41,7 @@ requires = [
     "cibuildwheel>=2.19.2,<3.0.0",
     "wheel>=0.43.0,<1.0.0",
     "delocate>=0.11.0,<1.0.0",
-    "cmake>=3.27.0,<4.0.0"
+    "cmake>=3.27.0"
 ]
 build-backend = "setuptools.build_meta"

@@ -52,7 +52,7 @@ build = [
     "cibuildwheel>=2.19.2,<3.0.0",
     "wheel>=0.43.0,<1.0.0",
     "delocate>=0.11.0,<1.0.0",
-    "cmake>=3.27.0,<4.0.0"
+    "cmake>=3.27.0"
 ]
 dev = [
     "pytest>=7.4.2,<8.0.0",
