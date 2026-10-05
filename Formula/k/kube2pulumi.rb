class Kube2pulumi < Formula
  desc "Upgrade your Kubernetes YAML to a modern language"
  homepage "https://github.com/pulumi/kube2pulumi"
  url "https://github.com/pulumi/kube2pulumi/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "1e2286e8d981e1abd0e96ff3c847b4c48af79fdcf4f081fd16918b554d1342f7"
  license "Apache-2.0"
  head "https://github.com/pulumi/kube2pulumi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a86935fbcf80d553344d488cae61b93cf2e6a6a3c6fe656c1dff36a55f2ca767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a86935fbcf80d553344d488cae61b93cf2e6a6a3c6fe656c1dff36a55f2ca767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80bfa3d647b568f6da5cad3b1e144471ff69520d281eb2001ff799913a18a8a5"
    sha256 cellar: :any,                 x86_64_linux:  "29704b11583cd898ebc2072946cf51ea27d0cf34ec969a1eeb178d54cb9ef934"
  end

  depends_on "go" => :build

  # Pulumi's PCL binder always starts a plugin host gRPC server on a loopback port.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/pulumi/kube2pulumi/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube2pulumi"

    generate_completions_from_executable(bin/"kube2pulumi", shell_parameter_format: :cobra)
  end

  test do
    ENV["PULUMI_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/kube2pulumi version")

    # Kubernetes resources would download the pulumi-kubernetes plugin; a CRD is reported locally.
    (testpath/"crd.yaml").write <<~YAML
      apiVersion: apiextensions.k8s.io/v1
      kind: CustomResourceDefinition
      metadata:
        name: crontabs.stable.example.com
    YAML

    output = shell_output("#{bin}/kube2pulumi go --directory #{testpath} --outputFile #{testpath}/main.go")
    assert_match "custom resource definitions cannot not be converted", output
    assert_match "github.com/pulumi/pulumi/sdk/v3/go/pulumi", (testpath/"main.go").read
  end
end
