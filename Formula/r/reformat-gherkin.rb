class ReformatGherkin < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Gherkin language"
  homepage "https://github.com/ducminh-phan/reformat-gherkin"
  url "https://files.pythonhosted.org/packages/7c/66/6da6919eb32a12e73b7af0fe4f82feb98a2280de9783a17d488cf4bb1bc6/reformat-gherkin-3.0.1.tar.gz"
  sha256 "a25e89fac3b632a7db7a3f217f4bfdc0f9cf4d8333d3ae9a830b0270beba6f3b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "26b1847b70e24413fb8dba0e424551c60aa94299ae781cb5f3b2953611393cd4"
    sha256 cellar: :any,                 arm64_sonoma:  "b60f966d6a213e479710c22d837f93a89e56e1b3adf3151fd66fa26b9d6a7b18"
    sha256 cellar: :any,                 ventura:       "db3dcb64b53ee45c1f8e85d2296f9366675d05c9827a965f45c4f29ab84cf2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6328c6f43909ce98af15cbcf5d278f7252bc8e56c1904c29c9ffa5801ef7e4ef"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/f7/06/9d81ad262e0146c0f2e94c6c450f6c4c490ce2e4711f30e546bb04883b62/cattrs-22.1.0.tar.gz"
    sha256 "94b67b64cf92c994f8784c40c082177dc916e0489a73a9a36b24eb18a9db40c6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "gherkin-official" do
    url "https://files.pythonhosted.org/packages/64/18/02ae1bc046028781711f39a26e5ead8ec4e636be01e22918870f6a6bbfb4/gherkin-official-24.0.0.tar.gz"
    sha256 "c126de30ac2a2262967ddde83912511267fa76be4883418974f529292e76c415"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"reformat-gherkin", shells:                 [:fish, :zsh],
                                                                 shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reformat-gherkin --version")

    (testpath/"test.feature").write <<~FEATURE
      Feature: Test feature
        Scenario: Test scenario
          Given a step
          When another step
          Then a final step
    FEATURE

    assert_match <<~EOS, shell_output("#{bin}/reformat-gherkin --check test.feature 2>&1", 1)
      Would reformat #{testpath}/test.feature
      All done! 💥 💔 💥
      1 file would be reformatted.
    EOS

    assert_match <<~EOS, shell_output("#{bin}/reformat-gherkin test.feature 2>&1")
      Reformatted #{testpath}/test.feature
      All done! ✨ 🍰 ✨
      1 file reformatted.
    EOS

    expected_content = <<~FEATURE
      Feature: Test feature

        Scenario: Test scenario
          Given a step
          When another step
          Then a final step
    FEATURE

    assert_equal expected_content, (testpath/"test.feature").read
  end
end
