class Bibiman < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://codeberg.org/lukeflo/bibiman"
  url "https://codeberg.org/lukeflo/bibiman/archive/v0.19.2.tar.gz"
  sha256 "43f0f4ae2c0b2c533a5a6590153b258e0b41b647ed45cfb73f76b65519e3e3da"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/lukeflo/bibiman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "871addca2e241334c483c7995134ecbe9e2ccea75fb859de965f840427eb3756"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e27924c654b54a12e1d2d3ec771f2e16a4338a1df5648681c156343901285d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc3dcc77a64b2f5435e97c136c41a36ac454cd9ce1f94acccb880a7879083c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da875be873675850599ba65e750a358cbc4af63dae3e69881f3a79bfccc21b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7b90a5a23021ec9fe4dd7988af782459d28d2deb5a6c01e5f9bea5c60dd48d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bibiman --version")

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
