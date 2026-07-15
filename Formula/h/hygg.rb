class Hygg < Formula
  desc "Simplifying the way you read. Minimalistic Vim-like TUI document reader"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.24.tar.gz"
  sha256 "0be91ce2ecceeaebcd40926b3c78f4867c056b93615c2a5ff01b4578d1f4b9dd"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71dc2dea271740426ee001e97061341034e6a1f05d621d6c31e77779e31c746e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5afad4606770990cc44b714cca874a65908dc487fd0a8ec6caa5468c2ff64b5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f61fed44b98010de8dca6fe977b31c45eb6cd548eefc9d2566703423d8fae90f"
    sha256 cellar: :any,                 arm64_linux:   "06649a690a63d76e8d30303b0fe4b9ede0cdc03e0bd2f0ef0e49d91abfef0f13"
    sha256 cellar: :any,                 x86_64_linux:  "c299d651bbbaae8cbd17d01493d211ea09799aff5e81967f7257c92a2a6f2519"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end
