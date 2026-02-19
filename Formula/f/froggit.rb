class Froggit < Formula
  desc "Modern, minimalist Git TUI"
  homepage "https://froggit-docs.vercel.app/"
  url "https://github.com/thewizardshell/froggit/archive/refs/tags/v1.2.0-beta.tar.gz"
  sha256 "9b3dc1b9669ae35b612abaa6d579b76b7ed78539a075efcdcc4de7e5e42dd113"
  license "MIT"
  head "https://github.com/thewizardshell/froggit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f8ac9946d5285e0d34d380ca2598e1f760bbd314730aad1c4bc99fef831a3bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8ac9946d5285e0d34d380ca2598e1f760bbd314730aad1c4bc99fef831a3bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f8ac9946d5285e0d34d380ca2598e1f760bbd314730aad1c4bc99fef831a3bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f66ced7923d6085a46579e4f5a19a6e9bdd3e600239261bd2bb0b3282dfa6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f504b9d10b4276a83a81b75bfd753af627613e2b58deda5347f24fa19827635"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Version:", shell_output("#{bin}/froggit -version")
    assert_match "Keyboard Shortcuts", shell_output("#{bin}/froggit -keys")
  end
end
