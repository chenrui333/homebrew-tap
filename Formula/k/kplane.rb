class Kplane < Formula
  desc "CLI for creating virtual Kubernetes control planes"
  homepage "https://github.com/kplane-dev/kplane"
  url "https://github.com/kplane-dev/kplane/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "531f9dfb92c85fe1940d17ba4220b19ac644b45819c83053bd523bf082113ded"
  license "Apache-2.0"
  head "https://github.com/kplane-dev/kplane.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kplane-dev/kplane/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kplane"

    generate_completions_from_executable(bin/"kplane", "completion")
  end

  test do
    output = shell_output("#{bin}/kplane --help")
    assert_match "Available Commands", output
    assert_match "doctor", output

    assert_match "Check local prerequisites", shell_output("#{bin}/kplane doctor --help")
  end
end
