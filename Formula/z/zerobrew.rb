class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "f7224dcde68f85a7f7d5e649ba9ef456d98e4dc6fa7dca6fbc9397ca936eb53e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ae0e243dccf235cf77c442c384ccb999092d529f92fac184f08c635c0ffb54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b40358ece14741f3e704b8ba7e6c4aa370703ada062b1847703762667b8713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88463d36c660808e64dd72e1c416347a850c90fe6fda5aafb9bcad3e4a5254b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15b1bcf2707b4584fdba0d40c4fbcfcf8a9e55a2df062d9669823200a34b9065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff413d75c7115363722d3d34251c44faa46511eb5a70c4ac62af46ded2562f50"
  end

  depends_on "rust" => :build

  def install
    inreplace "zb_cli/Cargo.toml", 'version = "0.1.2"', "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
