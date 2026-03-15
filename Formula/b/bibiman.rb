class Bibiman < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://codeberg.org/lukeflo/bibiman"
  url "https://codeberg.org/lukeflo/bibiman/archive/v0.19.5.tar.gz"
  sha256 "c8ae4f55ce1f74da292fa98ed1d5b7a530f3c7df37a8a14f111366ca23a10efb"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/lukeflo/bibiman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1697d0c569cfacca8ac8450023c1ca5534fb0723813b519b1c890d49ccd741b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8912f7b23a72ee0dd4f24b9187fcc266aa8d8a6061d3a4c373a69715d855a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d68c9761b00163accc6066a2526a04339afb75fcf8a4f67a11d5810d9fe1a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bd626b7e0b8f27e2cba8fac36cf552a943096624c634b6d8013aa7fbe5e5b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a229391eec974acd7ed27d43080f70260dff952aa8939b987f4734668331e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bibiman --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      test_file = testpath/"test.bib"
      test_file.write("")

      test_config = testpath/".config/bibiman/bibiman.toml"
      test_config.write("")

      output_log = testpath/"output.log"
      pid = spawn bin/"bibiman", "--config-file", test_config.to_s, test_file.to_s, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Bibliographic Entries", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
