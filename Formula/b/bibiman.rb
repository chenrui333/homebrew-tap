class Bibiman < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://codeberg.org/lukeflo/bibiman"
  url "https://codeberg.org/lukeflo/bibiman/archive/v0.19.1.tar.gz"
  sha256 "409d600df1346e89d435bdf6be3b6dee1f76f2a86eec6be203b459531ecba575"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/lukeflo/bibiman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "744d5b7b5cec3e719c2760754484ad12df384b8b7fe3ddc338c59d24c44c5ece"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f49c6cb2af0fac9b691340af0e5db52827644402e353acb7538c3e618dcd2dfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a69bbcb4160843aa9ef439431ad7311b372b4b38dc70b139c088c6e675e6167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46bdf0e8f24ed56dd0866beb338c6cf246e345981fa88b00c32d74367ed9f75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49897b1ec5806b3f91f55cd9d7152ce8f80ba3f56ac3c4390353b5802ab79f45"
  end

  depends_on "rust" => :build

  # Remove helix_stdx dependency from clipboard provider, upstream pr ref, https://codeberg.org/lukeflo/bibiman/pulls/69
  patch do
    url "https://codeberg.org/lukeflo/bibiman/commit/720c98cb758e318a824af8e10e8ce338513654fa.patch"
    sha256 "45c5d428d011c7d847eeb560a002770e7758c1c1fcbaf6a38a009f9bb04a0a80"
  end

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
