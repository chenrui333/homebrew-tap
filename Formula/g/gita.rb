class Gita < Formula
  include Language::Python::Virtualenv

  desc "Manage many git repos with sanity"
  homepage "https://github.com/nosarthur/gita"
  url "https://files.pythonhosted.org/packages/1d/89/8dd6dd79eadd70ff2f64b79f434637e384cd0490c2a626074e2a73c8a896/gita-0.16.8.2.tar.gz"
  sha256 "064e5cbcfa5df76409cfd8e70142f8153f6ecc40fb35d3a28a0a04054d5fb3fd"
  license "MIT"
  head "https://github.com/nosarthur/gita.git", branch: "main"

  depends_on "python@3.14"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gita --version")

    %w[repo1 repo2].each do |repo|
      mkdir repo do
        system "git", "init", "--initial-branch=main"
      end
    end

    # register repos
    system bin/"gita", "add", "repo1", "repo2"
    # create a group
    system bin/"gita", "group", "add", "-n", "my-group", "repo1", "repo2"

    output = shell_output("#{bin}/gita ll my-group")
    assert_match "repo1", output
    assert_match "repo2", output
  end
end
