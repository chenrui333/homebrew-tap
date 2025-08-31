class Mamediff < Formula
  desc "TUI editor for managing unstaged and staged Git diffs"
  homepage "https://github.com/sile/mamediff"
  url "https://github.com/sile/mamediff/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "fde4529baf2040a411f736805ce844c260fc3f43a50677fa9edf48bc9dea7222"
  license "MIT"
  head "https://github.com/sile/mamediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806c82a5236e44e77175f9becaeb13c27ae905e04528db438a884a1f81d1702c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83ee29d0f9d96f4c9e7b7ffb4914fb647ae389a35b24c9c8e8b729d8a68f39cc"
    sha256 cellar: :any_skip_relocation, ventura:       "b09517589123ae5a4e6270b5d36ba25834bbe5e7f66f58ce953ecb3890f758d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef285a5fcd91c351488000240e20891bb1e51c4e340bd91ed72bb1e33074b0e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mamediff --version")

    output = shell_output("#{bin}/mamediff 2>&1", 1)
    assert_match "no `git` command found, or not a Git directory", output
  end
end
