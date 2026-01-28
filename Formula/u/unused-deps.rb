class UnusedDeps < Formula
  desc "Determine any unused dependencies in java_library rules"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.5.1.tar.gz"
  sha256 "e6de6eb19a368efe1f56549c6afe9f25dbcee818161865ee703081307581ef4b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "135069459ea6641a0525fc964d6196d190f3a264dfb376d253259367e152f60a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17d807027c6d3f6d64406a2866dd8ed9c0cd217e94b6319b27e1bde3bb941310"
    sha256 cellar: :any_skip_relocation, ventura:       "b652a143b2b53a73aa470075877be2ce82feb96cb0c762f595106bf539c490e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807ed542ba5fce1c42f808653b2e352cdf3e45d4c4647b03c206f6ca3d9702f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"unused_deps"), "./unused_deps"
  end

  test do
    system bin/"unused_deps", "--version"
  end
end
