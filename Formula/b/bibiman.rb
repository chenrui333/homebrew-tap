class Bibiman < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://codeberg.org/lukeflo/bibiman"
  url "https://codeberg.org/lukeflo/bibiman/archive/v0.19.1.tar.gz"
  sha256 "409d600df1346e89d435bdf6be3b6dee1f76f2a86eec6be203b459531ecba575"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/lukeflo/bibiman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a9d6cce1a6c4baf992f28d49393398584f4e144df9c7edc6fa76ba075faec1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23fcca2d407cc17e29720c2a05222e49406cdce0c412892044b05c6a523a4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c894d33bec48c3bbe35b2ac6490c042eaebf4cc4c823d64d1f632b4fd7b56e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e61e60bedf3cf327ce2cdd7fdb1ab9024c9d433682db9123f5be809c79f0cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "814517526cc2c12d2881806aa905b38b13db06c445975e0e44e4c819b5ae5496"
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
