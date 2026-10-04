class Howto < Formula
  desc "Humble command-line assistant"
  homepage "https://github.com/nalgeon/howto"
  url "https://github.com/nalgeon/howto/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "336805619dd0cf5e59d10d376abfaf44d7c40f91dec6e982ea1db005784f5c78"
  license "MIT"
  head "https://github.com/nalgeon/howto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "447f878b9f0c18106fa994ec0607008840737a2a8007a4b37e3ee6193a31ad1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "447f878b9f0c18106fa994ec0607008840737a2a8007a4b37e3ee6193a31ad1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebcf803321b321f562a2a0739057e45844c952b4ce59f005d3915a445ddf8cfb"
    sha256 cellar: :any,                 x86_64_linux:  "635640dbe73dd8be89e8e4a6002e1c12a9682652cbc6573339a17881a45e3c1b"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/howto --version")

    assert_match "no command to run", shell_output("#{bin}/howto -run 2>&1", 1)

    config_dir = OS.mac? ? testpath/"Library/Application Support" : testpath/".config"
    history_path = config_dir/"howto/howto-history.json"
    history_path.atomic_write(["Calculate six times seven", "printf '%s' $((6 * 7))"].to_json)
    assert_match "\n42\n", shell_output("#{bin}/howto -run")
  end
end
