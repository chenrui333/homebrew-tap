class Hygg < Formula
  desc "Simplifying the way you read"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.17.tar.gz"
  sha256 "f657312f7071300561d8e73c382b7ff2350f389355ff55db0053fb4584062f85"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ff5a86387908ae7fc6913c90bb4d81fbf7c5e6ae5159eb14851576f9b44af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d9fadc869d7facc1cc13fa8b5fcfbf260f07c3d9a349e9ef08b9751a6af44e"
    sha256 cellar: :any_skip_relocation, ventura:       "3c0165b8bbcf8b4c602143c12d816be8d7a480b5592acd47ee15c780872264f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ca6314d0dcda0155a7f3b4b672b4ce0decf4b86097ce7d78bb49497f573dd59"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end
