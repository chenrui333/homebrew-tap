class Kube2pulumi < Formula
  desc "Upgrade your Kubernetes YAML to a modern language"
  homepage "https://github.com/pulumi/kube2pulumi"
  url "https://github.com/pulumi/kube2pulumi/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "1e2286e8d981e1abd0e96ff3c847b4c48af79fdcf4f081fd16918b554d1342f7"
  license "Apache-2.0"
  head "https://github.com/pulumi/kube2pulumi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "397a33b6a2e41d806c38f8c1d0c0bec9fd7e32daa5fb9e171741a3f09f0e18c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d63678d88291753cb385e9dca29a37c2e7a4db95c8a9c7e7c059dde3bfde5974"
    sha256 cellar: :any_skip_relocation, ventura:       "c8006543a4dd7363f05d7e82794d27be478a36b49c6103604f836040bda1a4f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b5d464f19a880b584536729f748b1ce00cdf66a8a92a552932864c4e3efd4a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pulumi/kube2pulumi/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube2pulumi"

    generate_completions_from_executable(bin/"kube2pulumi", shell_parameter_format: :cobra)
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
