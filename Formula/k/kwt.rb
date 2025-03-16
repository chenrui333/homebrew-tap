class Kwt < Formula
  desc "Kubernetes Workstation Tools CLI"
  homepage "https://github.com/carvel-dev/kwt"
  url "https://github.com/carvel-dev/kwt/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "705e95244dda01be18bc7f58c7748ea55590c917504683bb1252569bafe8df9d"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kwt.git", branch: "develop"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/carvel-dev/kwt/pkg/kwt/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kwt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kwt version")

    output = shell_output("#{bin}/kwt workspace list 2>&1", 1)
    assert_match "Error: Building Kubernetes config", output
  end
end
