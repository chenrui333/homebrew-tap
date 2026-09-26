class UnusedDeps < Formula
  desc "Determine any unused dependencies in java_library rules"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "fa0b905032d49a621679e7318875736e451895a1417d992fbbebd27f82b83c38"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc0cfff4fdf03628eafdfaa36a5ec17ea2a99bff7a6bd18d5fad7948927afe83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc0cfff4fdf03628eafdfaa36a5ec17ea2a99bff7a6bd18d5fad7948927afe83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a0c00ac3d2bde8e7ba072926497e5fe7bf7a6921e91ea926f60faf9355da13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca7e9cf4d67fc7c9f395ca559ed6a07441be3269edd6241ab1abf749abc2baa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}", output: bin/"unused_deps"), "./unused_deps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unused_deps --version")

    (testpath/"bin").mkpath
    output = with_env(PATH: (testpath/"bin").to_s) do
      shell_output("#{bin}/unused_deps 2>&1", 2)
    end
    assert_match "executable file not found", output
  end
end
