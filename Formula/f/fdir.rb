class Fdir < Formula
  include Language::Python::Virtualenv

  desc "Search language for your filesystem"
  homepage "https://github.com/VG-dev1/fdir"
  url "https://github.com/VG-dev1/fdir/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "8fc0f78ee9206fb4d42dcc3cead83023cefa5445879eb3829d577d036f968670"
  license "MIT"
  head "https://github.com/VG-dev1/fdir.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "df5d8490f952bf976804dc4ae02cf2c5a12682c3c0cd6371b5c078ac65a18d11"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"report.txt").write("Quarterly report")
    output = shell_output("#{bin}/fdir name --keyword report --nocolor")
    assert_match "report.txt", output
    assert_match version.to_s, shell_output("#{bin}/fdir version")
  end
end
