class Envtpl < Formula
  desc "Render Go templates on the command-line with shell environment variables"
  homepage "https://github.com/chenrui333/envtpl"
  url "https://github.com/chenrui333/envtpl/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "60d82242c64b577fb4522fc49da8cf25582c8ddb6b1c4905d8d895acacac0d20"
  license "MIT"
  head "https://github.com/chenrui333/envtpl.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/envtpl"
  end

  test do
    system bin/"envtpl", "--version"

    # test envtpl with a template file
    (testpath/"test.tmpl").write <<~EOS
      Hello, {{ .ENV_NAME }}!
    EOS
    assert_match "Hello, Homebrew!", shell_output("ENV_NAME=Homebrew #{bin}/envtpl test.tmpl")
  end
end
