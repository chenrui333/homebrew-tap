class Bibiman < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://codeberg.org/lukeflo/bibiman"
  url "https://codeberg.org/lukeflo/bibiman/archive/v0.19.5.tar.gz"
  sha256 "c8ae4f55ce1f74da292fa98ed1d5b7a530f3c7df37a8a14f111366ca23a10efb"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/lukeflo/bibiman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82bb25eda1b6f07a84bf7932b735937e74f560c97f07fea32be4a1dc14d91e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae28c6246ed5c7e5f34eb835997a81aef517f224e999a17fcdb699c695d9144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d94696a160aba5e4199e89c963ca202cb41c18eca8776e9ac0868993573edf3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c940fb99cce21d53e0bbca2fbc975b921bf06b5c8612cd1255bd3cbb2e2c4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ce596d5c8f58c52d1d02ced3dac3d72bafbeefbd5263428214240d54069182"
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
