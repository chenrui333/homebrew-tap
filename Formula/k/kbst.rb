class Kbst < Formula
  desc "Kubestack framework CLI"
  homepage "https://www.kubestack.com/"
  url "https://github.com/kbst/kbst/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a02615028a00f4ce1e0121f3c8822dc5245f79e4e34bb85de48cc6ba6b3d5047"
  license "Apache-2.0"
  head "https://github.com/kbst/kbst.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca67de1d4e643de0f8c4eb2f43edbe9324c845e4643b44780bdc3874eb6e068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42707d6ac672b9ba3cb1815205ef399ddcd5ac6e5adf9aab22a5f52a6be94ec6"
    sha256 cellar: :any_skip_relocation, ventura:       "9606425accd39e2fcf0cbb47cc320ae91a29a134543c7f20e3b06e1cc13b2f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d3bc137d0e58a1fd07934dd1aafaddf0522ec6af9ade7a2e7e4242bd091d9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kbst", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbst --version")

    output = shell_output("#{bin}/kbst init aks example.com testCluster eastus testResourceGroup 2>&1", 1)
    assert_match "author field is required", output
    assert_match "# Welcome to Kubestack", (testpath/"kubestack-starter-aks/README.md").read
  end
end
