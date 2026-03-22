class Kaydet < Formula
  include Language::Python::Virtualenv

  desc "Queryable personal database for notes, logs, and todos"
  homepage "https://github.com/miratcan/kaydet"
  url "https://github.com/miratcan/kaydet/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "58f52287921b6f3230e6b34f1c33f129b167efa710b73e38622f1a3f411cd8b2"
  license "MIT"
  head "https://github.com/miratcan/kaydet.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a13e539315259ce07357f0e37c7747db591621e70de15bc09b02effb95cf1ba0"
  end

  depends_on "python@3.14"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    config_home = testpath/"config"
    storage_dir = testpath/"storage"
    index_dir = testpath/"index"
    (config_home/"kaydet").mkpath
    config_path = config_home/"kaydet/config.ini"
    config_path.write <<~INI
      [SETTINGS]
      STORAGE_DIR = #{storage_dir}
      LOG_DIR = #{index_dir}
    INI

    with_env(XDG_CONFIG_HOME: config_home.to_s) do
      system bin/"kaydet", "Built tap formula #work status:done"

      assert_match version.to_s, shell_output("#{bin}/kaydet --version")

      output = shell_output("#{bin}/kaydet --filter '#work'")
      assert_match "Built tap formula", output
      assert_match "status:done", output

      tags = shell_output("#{bin}/kaydet --tags")
      assert_match "work", tags
    end
  end
end
