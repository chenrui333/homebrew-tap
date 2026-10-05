class Kwt < Formula
  desc "Kubernetes Workstation Tools CLI"
  homepage "https://github.com/carvel-dev/kwt"
  url "https://github.com/carvel-dev/kwt/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "705e95244dda01be18bc7f58c7748ea55590c917504683bb1252569bafe8df9d"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kwt.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc57ec7bff070e7b7a9f36f4425d18e4b2ca2ac2f082607d57a98410710a754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dc57ec7bff070e7b7a9f36f4425d18e4b2ca2ac2f082607d57a98410710a754"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "000e565f0df0b3d25edcb04ea90994950c68f81b4f8aad951040325670d598f5"
    sha256 cellar: :any,                 x86_64_linux:  "b5e6836b9ee186980ce3560ce81a0d6ea2ac92eaa9688fb7bdefa4f655cb269e"
  end

  depends_on "go" => :build

  deny_network_access!

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
