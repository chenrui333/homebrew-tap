class DesigncraftCli < Formula
  desc "Headless DesignCraft CLI and MCP server for page layout and PDF/EPUB export"
  homepage "https://getartcraft.com/apps/designcraft"
  url "https://github.com/storytold/designcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "2648d4b58bf397985a70c07c785ff0342c9dbda30e614eae23d880d65a875589"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/designcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce35f29139f6b93cff3a3512d5897f25915d96bfcb0032091d7f84d9d713f5d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94bb382a18aa451ee977953401f7210f5bb7298109c36ae754496d3aa99ef75f"
    sha256 cellar: :any,                 arm64_linux:   "33094fa406b997bd999218c6bc182e2243a8086e504c2616b9f00c48917d276d"
    sha256 cellar: :any,                 x86_64_linux:  "772c217fa5ad06b29c02fe37eaefcb362c8eed01ec959152d736a0192be9eb48"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/designcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/designcraft-cli --version")

    (testpath/"test.script").write <<~EOS
      frame.create {"rect": [72, 72, 300, 200], "content": "text", "text": "Homebrew"}
      story.get {"story": "$0.story"}
    EOS
    report = JSON.parse(shell_output("#{bin}/designcraft-cli script test.script " \
                                     "--save test.designcraft --export test.png"))
    assert_equal 2, report["completed"]
    assert_equal "Homebrew", report["results"][1]["text"]
    assert_equal "\x89PNG".b, (testpath/"test.png").binread(4)

    info = JSON.parse(shell_output("#{bin}/designcraft-cli run --in test.designcraft --cmd document.inspect"))
    assert_includes info["stories"].map { |story| story["preview"] }, "Homebrew"
  end
end
