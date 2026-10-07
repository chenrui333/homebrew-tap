class Bibiman < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://codeberg.org/lukeflo/bibiman"
  url "https://codeberg.org/lukeflo/bibiman.git",
      tag:      "v0.19.6",
      revision: "813e87dd85f1e0a60bf5a7617dc4567408fa98b0"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/lukeflo/bibiman.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7924212bfe728547e7ff0985c40ec76a99c4ca9dd663ea3cb1ad4a0ea2cb065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c8005f6e8c07bfc539276cd20ef02f32c5e8d8bc76e39deb94a86a69726ab1f"
    sha256 cellar: :any,                 arm64_linux:   "bb8ecf781973aae44d9e1140bbe9ad1c12f39fe22763f7cfc88e05ffc3585dbf"
    sha256 cellar: :any,                 x86_64_linux:  "233a0ef49de1a26bb246cbfe74f50695b81aa355dbd597fb781224a876a7c4cf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # TODO: Remove when the release Cargo.lock records the bibiman version (v0.19.6 still says 0.19.5)
    inreplace "Cargo.lock", /(name = "bibiman"\nversion = )"0\.19\.5"/, "\\1\"#{version}\""
    system "cargo", "fetch", *std_cargo_fetch_args
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
