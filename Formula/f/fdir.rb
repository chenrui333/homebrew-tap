class Fdir < Formula
  include Language::Python::Virtualenv

  desc "Search language for your filesystem"
  homepage "https://github.com/VG-dev1/fdir"
  url "https://github.com/VG-dev1/fdir/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "8fc0f78ee9206fb4d42dcc3cead83023cefa5445879eb3829d577d036f968670"
  license "MIT"
  head "https://github.com/VG-dev1/fdir.git", branch: "main"

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
