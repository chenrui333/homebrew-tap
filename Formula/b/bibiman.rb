class Bibiman < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://codeberg.org/lukeflo/bibiman"
  url "https://codeberg.org/lukeflo/bibiman/archive/v0.19.3.tar.gz"
  sha256 "96c482d7cadf9840289c59ec960541a115a87c54af5d1bf5c24c444fd9081b14"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/lukeflo/bibiman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ac3f4cfcb4f355814340ed2d363431aef77ba349a1ad3d99ced48caf978c2b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd4a4dbb618431874ac2c11e1b5220915dbfab12f0fb5f13adca3a82b24df21c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df558fe484460578d56b249ebf605ae5376eb01eef44346fba81c05a80f7845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a3b5688bb41748e597fbb0caa38294bc64de782b1fa815cd79e1fe10f4862d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a3dbd924e3fca2da0d9461e652ab34f8abe0c2b192949313bc53d024feb4705"
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
