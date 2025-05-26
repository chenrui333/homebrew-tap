class UnusedDeps < Formula
  desc "Determine any unused dependencies in java_library rules"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "444a9e93e77a45f290a96cc09f42681d3c780cfbf4ac9dbf2939b095daeb6d7d"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d940dd0dd960b9e4a850bee268b6bd75d3f5a0f3629192c75f30e1c1231e0d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8b0dc33e4645928fd510857fd3f8d73f6c13dd4f72af23245e2d7b9e4f495af"
    sha256 cellar: :any_skip_relocation, ventura:       "4167007b61ce6ea680843aae3aa146073caf74abd65102fbb86d413a5294d9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3af5db6f0d547ec3528b3428de51b87c67800dbb79c9bee13dc4380dad25e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"unused_deps"), "./unused_deps"
  end

  test do
    system bin/"unused_deps", "--version"
  end
end
