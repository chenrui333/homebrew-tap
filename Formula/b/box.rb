class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.6.6/box.phar"
  sha256 "aa0966319f709e74bf2bf1d58ddb987903ae4f6d0a9d335ec2261813c189f7fc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be8981a47a1e2c29f0cdd24f0c2aa664adf6ab044685a1d2bf55583dfa905ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b76ce6f96ebd852b6815a7dcd7b32cea29b3a0dcd0a5ab819ce2a987d75fbdbc"
    sha256 cellar: :any_skip_relocation, ventura:       "acbc34c987114755b148eb8a7df13c9bccca0e112b3e047ae7dd0af41ffb0a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb862b2413f57067b5b8b6e26c9f0445b832c094e3c6c803b0d883471f6d844"
  end

  depends_on "php"

  def install
    bin.install "box.phar" => "box"
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/box --version")
    system bin/"box", "--version"

    (testpath/"index.php").write <<~PHP
      <?php
      echo "Hello, World!";
    PHP

    (testpath/"box.json").write <<~JSON
      {
        "main": "index.php",
        "output": "test.phar"
      }
    JSON

    # override error_reporting to 8191, which suppresses deprecation warnings.
    system "php", "-d", "error_reporting=8191", bin/"box", "compile"
    assert_path_exists testpath/"test.phar"
    assert_match "Hello, World!", shell_output("php test.phar")
  end
end
