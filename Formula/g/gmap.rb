class Gmap < Formula
  desc "CLI for visualizing Git activity"
  homepage "https://github.com/seeyebe/gmap"
  url "https://github.com/seeyebe/gmap/archive/refs/tags/0.3.3.tar.gz"
  sha256 "a53ef4474409df65bbe600b2c239776e498a06a956143c7d7f2fcef03dd32f2e"
  license "MIT"
  head "https://github.com/seeyebe/gmap.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a26539820b19c8a99a921dffe82a0ef8a9168cd76957d0bd76f0c5780e99abb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14bb167ef9c86ed4a3e44276f76adfaeb7b590b6bba05032afd142ba31609c01"
    sha256 cellar: :any_skip_relocation, ventura:       "8b6789d14df44871ad9f7a4b054f704f467f101e7ded4c7124d376e44d9558f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d81e41b65956a5426e3b08230dd4d7d87e6ad8e42ffbaec5e0984922b58c50f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gmap --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"
    assert_match "Commit Activity Heatmap", shell_output("#{bin}/gmap heat")
  end
end
