class Kbst < Formula
  desc "Kubestack framework CLI"
  homepage "https://www.kubestack.com/"
  url "https://github.com/kbst/kbst/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a02615028a00f4ce1e0121f3c8822dc5245f79e4e34bb85de48cc6ba6b3d5047"
  license "Apache-2.0"
  head "https://github.com/kbst/kbst.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ddc0dc7e29ac80d36302c3c0b54e3730c44662d0df82fab75355ccd4233b720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb4631a2c7d6bfb9884b8a2c453e488e1063476e0f01726aa590aa4fd61d5fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61f7a83560d136c3b54fe9da6a6fd08b4a27de4e38aa5f609fbec29433b0e8bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "811aafcf9441f7f1bd339b3b738c688007e1dbe797f3416a887fb998931a0e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4412bc09ef22a5e9df27bcc26fbcf8fba9f16094382da9c2ae29804d83df93f2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kbst", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbst --version")

    # spellchecker:ignore-next-line
    output = shell_output("#{bin}/kbst init aks example.com testCluster eastus testResourceGroup 2>&1", 1)
    assert_match "author field is required", output
    assert_match "# Welcome to Kubestack", (testpath/"kubestack-starter-aks/README.md").read
  end
end
