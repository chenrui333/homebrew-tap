class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://github.com/carvel-dev/kbld/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "06ec0c144ea24f462fad87bd57463e28cf853d6f58a47a434e79a2deb49d23cd"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

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
