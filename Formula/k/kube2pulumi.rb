class Kube2pulumi < Formula
  desc "Upgrade your Kubernetes YAML to a modern language"
  homepage "https://github.com/pulumi/kube2pulumi"
  url "https://github.com/pulumi/kube2pulumi/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "1e2286e8d981e1abd0e96ff3c847b4c48af79fdcf4f081fd16918b554d1342f7"
  license "Apache-2.0"
  head "https://github.com/pulumi/kube2pulumi.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/pulumi/kube2pulumi/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube2pulumi"

    generate_completions_from_executable(bin/"kube2pulumi", "completion")
  end

  test do
    ENV["PULUMI_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/kube2pulumi version")

    (testpath/"test.yaml").write <<~YAML
      apiVersion: v1
      kind: Pod
      metadata:
        name: nginx
        labels:
          app: nginx
      spec:
        containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
          - containerPort: 80
    YAML

    system bin/"kube2pulumi", "go", "--directory", testpath, "--outputFile", testpath/"main.go"
    assert_match "github.com/pulumi/pulumi/sdk/v3/go/pulumi", (testpath/"main.go").read
  end
end
