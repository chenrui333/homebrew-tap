class ReformatGherkin < Formula
  include Language::Python::Virtualenv

  desc "Formatter for Gherkin language"
  homepage "https://github.com/ducminh-phan/reformat-gherkin"
  url "https://files.pythonhosted.org/packages/7c/66/6da6919eb32a12e73b7af0fe4f82feb98a2280de9783a17d488cf4bb1bc6/reformat-gherkin-3.0.1.tar.gz"
  sha256 "a25e89fac3b632a7db7a3f217f4bfdc0f9cf4d8333d3ae9a830b0270beba6f3b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "c0c125f367ef3acca4896ee4c45e290628df9592fb34dc235d2593d4d6caf230"
    sha256 cellar: :any,                 arm64_sonoma:  "11fb9b3cff1c5676f93594ee60f557e802a3b52c5a9a5c03da1e7f527a0339c0"
    sha256 cellar: :any,                 ventura:       "87cc944f9f92b734838de0ae331481dfcb43c25d058bae6a700244716fe828c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2fd19e5cee4ba7da83c52056b3beb96eadf30eaf4819dfcb324e1ebe205331"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/f7/06/9d81ad262e0146c0f2e94c6c450f6c4c490ce2e4711f30e546bb04883b62/cattrs-22.1.0.tar.gz"
    sha256 "94b67b64cf92c994f8784c40c082177dc916e0489a73a9a36b24eb18a9db40c6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "gherkin-official" do
    url "https://files.pythonhosted.org/packages/64/18/02ae1bc046028781711f39a26e5ead8ec4e636be01e22918870f6a6bbfb4/gherkin-official-24.0.0.tar.gz"
    sha256 "c126de30ac2a2262967ddde83912511267fa76be4883418974f529292e76c415"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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
