class Quokka < Formula
  desc "Inspect and clean iOS and Android devices over USB"
  homepage "https://github.com/dutradotdev/quokka"
  url "https://github.com/dutradotdev/quokka/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "ea0356c1b3b85dceddec50edfde30cfe7f25fa67be2a3ecb51ed092fad770e79"
  license "MIT"
  head "https://github.com/dutradotdev/quokka.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/quokka-cli")
  end

  test do
    assert_match "quokka #{version}", shell_output("#{bin}/quokka --version")
    assert_match "short alias", shell_output("#{bin}/qk --help")
  end
end
