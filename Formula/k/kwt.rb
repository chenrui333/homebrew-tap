class Kwt < Formula
  desc "Kubernetes Workstation Tools CLI"
  homepage "https://github.com/carvel-dev/kwt"
  url "https://github.com/carvel-dev/kwt/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "705e95244dda01be18bc7f58c7748ea55590c917504683bb1252569bafe8df9d"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kwt.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee4370e99474d8ced8680bfbf3acdb43fd5c60fe6cc8ee04b035af023f05a55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19776158ccc5a075e171f91a66de66df25dfd292926ec8d2592402fb3812a0bd"
    sha256 cellar: :any_skip_relocation, ventura:       "62646bad5b12a76d49f0b52e216c0008d9d16bf716ff756e0c84b0496241247c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f0abb6103603265752531af5c5dc91130c4a2bf72245b366f888e5baa76c2fb"
  end

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
