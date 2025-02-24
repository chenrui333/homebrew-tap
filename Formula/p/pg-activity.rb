class PgActivity < Formula
  include Language::Python::Virtualenv

  desc "Top like application for PostgreSQL server activity monitoring"
  homepage "https://github.com/dalibo/pg_activity"
  url "https://files.pythonhosted.org/packages/26/09/2d85e2f0806e18784a16e71d85d02b6ac5e1f94165efb0203648a805abe8/pg_activity-3.6.0.tar.gz"
  sha256 "4effb6adabd484fd813a045dd008ebf930aa08556193a24576e2fabb2a2ec1bf"
  license "PostgreSQL"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end
end
