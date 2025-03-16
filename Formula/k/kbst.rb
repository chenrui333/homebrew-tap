class Kbst < Formula
  desc "Kubestack framework CLI"
  homepage "https://www.kubestack.com/"
  url "https://github.com/kbst/kbst/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a02615028a00f4ce1e0121f3c8822dc5245f79e4e34bb85de48cc6ba6b3d5047"
  license "Apache-2.0"
  head "https://github.com/kbst/kbst.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kbst", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbst --version")

    output = shell_output("#{bin}/kbst init aks example.com testCluster eastus testResourceGroup 2>&1", 1)
    assert_match "author field is required", output
    assert_match "# Welcome to Kubestack", (testpath/"kubestack-starter-aks/README.md").read
  end
end
