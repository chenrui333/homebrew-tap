class Kube2pulumi < Formula
  desc "Upgrade your Kubernetes YAML to a modern language"
  homepage "https://github.com/pulumi/kube2pulumi"
  url "https://github.com/pulumi/kube2pulumi/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "1e2286e8d981e1abd0e96ff3c847b4c48af79fdcf4f081fd16918b554d1342f7"
  license "Apache-2.0"
  head "https://github.com/pulumi/kube2pulumi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc3e4e27fb63085c52248291ab48895fde62ed52008fd8e2bcaf55a6f52ee511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc3e4e27fb63085c52248291ab48895fde62ed52008fd8e2bcaf55a6f52ee511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc3e4e27fb63085c52248291ab48895fde62ed52008fd8e2bcaf55a6f52ee511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3a7d65ec9a211978cb6d5c0b75c429a531fd489765992818404df9ffe4721f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c51e99638b5f07e5184df79a98709e65d8c28c2d8ef98895d05fbadfac46718b"
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
