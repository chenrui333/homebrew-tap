class UnusedDeps < Formula
  desc "Determine any unused dependencies in java_library rules"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "fa0b905032d49a621679e7318875736e451895a1417d992fbbebd27f82b83c38"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ca0d4db6264d3e7ff4fe6057d4aaeb3dc338b5e38825044af1d92f1c4042b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca0d4db6264d3e7ff4fe6057d4aaeb3dc338b5e38825044af1d92f1c4042b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f22cd7d2370e8e0be4c877b958f08dfcd0034a5cfaa357aba2ad8c2d0c7a3746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c135ff705b0647fe79d67fa1ddafb172d6af0f98ed4c6284e93aeb36da6bdcb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
