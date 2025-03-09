class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "06ec0c144ea24f462fad87bd57463e28cf853d6f58a47a434e79a2deb49d23cd"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b67e9bd84707498511753ee887cc735225c96ec08bd1dd70bffe24a2443d6094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e49a89720374103a99764319f7f556cde50e79cf4213ea9aca2673fef8ed554a"
    sha256 cellar: :any_skip_relocation, ventura:       "25bc7a1422b0b00e79ababc7b70854bb18749df308431d90a4194187d3e7c1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3d0c30f96a09b3709dc93326300c7006ae95f0545d0ec7267b5621294400c92"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X carvel.dev/kbld/pkg/kbld/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kbld"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbld --version")

    test_yaml = testpath/"test.yml"
    test_yaml.write <<~YAML
      ---
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: test-deployment
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: test
        template:
          metadata:
            labels:
              app: test
          spec:
            containers:
            - name: test-container
              image: nginx:1.14.2
    YAML

    output = shell_output("#{bin}/kbld -f #{test_yaml}")
    assert_match "image: index.docker.io/library/nginx@sha256", output
  end
end
