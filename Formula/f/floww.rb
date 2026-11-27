class Floww < Formula
  desc "Manage application workflows and desktop workspaces"
  homepage "https://github.com/dagimg-dot/floww"
  url "https://github.com/dagimg-dot/floww/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "ae5b90eb2e3f5e3e5af1503f52fa2d50b130a407eceb97a2994bf6bfe1e268a7"
  license "MIT"
  head "https://github.com/dagimg-dot/floww.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "d574672be265d4e6d93c4227189995994aed92d32b96177989fa6d3cd6c0e5bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ee4a33af861a7ecb952f4410d71224b85b34991dc15bfeafc83336b19fd236b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee4a33af861a7ecb952f4410d71224b85b34991dc15bfeafc83336b19fd236b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "139f06bf22cfa67cb32b8eb2f10cb45df14efc8a74de3cfa2309440c9e999ad7"
    sha256 cellar: :any,                 x86_64_linux:  "f0e9304e373fdef9091886d55cb79eaa5074ce96b77c07b728238755d031901b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/floww"

    generate_completions_from_executable(bin/"floww", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/floww --version")

    (testpath/"workflow.yaml").write <<~YAML
      workspaces:
        - target: 1
          apps:
            - name: Terminal
              exec: xterm
    YAML
    assert_match "Workflow is valid", shell_output("#{bin}/floww validate --file workflow.yaml 2>&1")
  end
end
