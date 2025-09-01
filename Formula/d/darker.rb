class Darker < Formula
  include Language::Python::Virtualenv

  desc "Apply Black formatting only in regions changed since last commit"
  homepage "https://github.com/akaihola/darker"
  url "https://files.pythonhosted.org/packages/df/78/ad6af1661c2eca0ec69b7ff7c99d95dcae29c5e0071c7ebc98e6670f4663/darker-3.0.0.tar.gz"
  sha256 "eb53776f037fcf42b1f5a56f62fb841cd871d95a78a388536dc91dc4355ce8bb"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84c75ffa9b0c43f257ea740d48c7c2a83db81a35db7a167fa04d182953c2b75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72e295e9f0d1fc223d371bc138ef1ff2f1162a307dade6dae33b086f5a49517"
    sha256 cellar: :any_skip_relocation, ventura:       "2a471449d0746a974a2ab0a591139deadc6b2e133486d95b00995f6275030c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65345b490f3e68b5074c884dd0f5b6bdefc2a446c93d32c0134ff60e923d01ec"
  end

  depends_on "python@3.13"

  resource "darkgraylib" do
    url "https://files.pythonhosted.org/packages/ed/f8/098b981e982f5bd4616e42409debde17783757405781c01e3fc9ead5012d/darkgraylib-2.4.0.tar.gz"
    sha256 "d270b2c5a50be3575f50d26ec22adcd934f9a7a9edcd3c5400fddf8fb1e89af7"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # prints 1.2.1 rather than 2.1.1
    system bin/"darker", "--version"

    # cannot get test working
    # `Command '['git', 'rev-parse', '--is-inside-work-tree']' returned non-zero exit status 1`
  end
end
