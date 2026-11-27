class Floww < Formula
  desc "Manage application workflows and desktop workspaces"
  homepage "https://github.com/dagimg-dot/floww"
  url "https://github.com/dagimg-dot/floww/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "ae5b90eb2e3f5e3e5af1503f52fa2d50b130a407eceb97a2994bf6bfe1e268a7"
  license "MIT"
  head "https://github.com/dagimg-dot/floww.git", branch: "main"

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
