class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar"
  sha256 "a39021ac809530ea607580dbf93afbc46ba02f86b6cffd03de4b126ca53079f6"
  license "MIT"

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("php -d memory_limit=512M #{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
