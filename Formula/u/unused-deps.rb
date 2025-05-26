class UnusedDeps < Formula
  desc "Determine any unused dependencies in java_library rules"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "444a9e93e77a45f290a96cc09f42681d3c780cfbf4ac9dbf2939b095daeb6d7d"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"unused_deps"), "./unused_deps"
  end

  test do
    system bin/"unused_deps", "--version"
  end
end
