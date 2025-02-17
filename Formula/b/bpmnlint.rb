class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-11.1.0.tgz"
  sha256 "5364956ff2a2f7d90e1fc10cf22bca6526f8766bed95608fcaa4c83c29df869c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b53322e6d8b3b3dd99746609c6bcf876824c2da0f3d47373a67eef716ac83f34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e2f950d68306fef6571a72c324b47df7090d5f650616b04578898caf2defb4"
    sha256 cellar: :any_skip_relocation, ventura:       "68f09a58722a1e5e84c6e0ab01e6e37af4cd077a8510c037e42c7da683d352b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df64c0f9a6d27a00dd6ea450df4bfe777aa0781a41519fd5c54b7dfec5903749"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/bpmnlint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bpmnlint --version")

    system bin/"bpmnlint", "--init"
    assert_match "\"extends\": \"bpmnlint:recommended\"", (testpath/".bpmnlintrc").read

    (testpath/"diagram.bpmn").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" id="Definitions_1">
        <bpmn:process id="Process_1" isExecutable="false">
          <bpmn:startEvent id="StartEvent_1"/>
        </bpmn:process>
      </bpmn:definitions>
    XML

    output = shell_output("#{bin}/bpmnlint diagram.bpmn 2>&1", 1)
    assert_match "Process_1     error  Process is missing end event   end-event-required", output
  end
end
