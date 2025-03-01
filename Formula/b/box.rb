class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.6.4/box.phar"
  sha256 "4e52b19d9e74cd503d128c2b0e29b1b3361e96fbf17a48faeee120cb1e865161"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9c668a837cf358fc88c31c58e4143c36398c8921249d736004f71594f4e7562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebacc4df5938a821a8ef3918295146a3c192771e335d86dfa43ed02eeb31c5f7"
    sha256 cellar: :any_skip_relocation, ventura:       "32e8cb6dc487adb43fe62f0378920df104f2202f437e33c231e1be67a6294b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942bb93cc3c4251da37ee6dcfb3b5a787a2a0d3525c3b8d4c441667bec702970"
  end

  depends_on "php"

  def install
    bin.install "box.phar" => "box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/box --version")

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
